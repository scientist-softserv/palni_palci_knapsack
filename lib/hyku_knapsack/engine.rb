# frozen_string_literal: true

module HykuKnapsack
  class Engine < ::Rails::Engine
    isolate_namespace HykuKnapsack

    def self.load_translations!
      HykuKnapsack::Engine.root.glob("config/locales/**/*.yml").each do |path|
        I18n.load_path << path.to_s
      end

      # Let's have unique load_paths. Later entries in the I18n.load_path array take precedence
      # over earlier entries (e.g. lower array index means lower precedence). So we need to reverse
      # the array, then call uniq (which will drop duplicates that show up later in the array).
      # Then reverse again. (You know, kind of like an Uno reverse battle.)
      I18n.load_path = I18n.load_path.reverse.uniq.reverse
      I18n.backend.reload!
    end

    initializer :append_migrations do |app|
      # Only add the migrations if they are not already copied
      # via the rake task. Allows gem to work both with the install:migrations
      # and without it.
      if !app.root.to_s.match(HykuKnapsack::Engine.root.to_s) &&
         app.root.join('db/migrate').children.none? { |path| path.fnmatch?("*.hyku_knapsack.rb") }
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    config.before_initialize do
      # Adding translation files to the load path
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]

      # Setting up Devise parameters if the application has the user_devise_parameters method
      # if Hyku::Application.respond_to?(:user_devise_parameters=)
      #   Hyku::Application.user_devise_parameters = [
      #     :database_authenticatable,
      #     :invitable,
      #     :omniauthable,
      #     :recoverable,
      #     :registerable,
      #     :rememberable,
      #     :trackable,
      #     :validatable,
      #     omniauth_providers: [:saml, :openid_connect, :cas]
      #   ]
      # end
    end

    config.after_initialize do
      # Loading decorators for caching or dynamic evaluation depending on configuration
      HykuKnapsack::Engine.root.glob("app/**/*_decorator*.rb").sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      HykuKnapsack::Engine.root.glob("lib/**/*_decorator*.rb").sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Hyrax::DerivativeService.services = [
        IiifPrint::PluggableDerivativeService
      ]

      # Override engine views with application views and adjust the view paths accordingly
      ([::ApplicationController] + ::ApplicationController.descendants).each do |klass|
        paths = klass.view_paths.collect(&:to_s)
        paths = [HykuKnapsack::Engine.root.join('app', 'views').to_s] + paths
        klass.view_paths = paths.uniq
      end
      ::ApplicationController.send :helper, HykuKnapsack::Engine.helpers

      # Ensure translations are prioritized last after all initializations
      HykuKnapsack::Engine.load_translations!
    end
  end
end
