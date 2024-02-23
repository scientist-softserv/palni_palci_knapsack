require_relative 'boot'

require 'rails/all'
require 'i18n/debug' if ENV['I18N_DEBUG']

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
groups = Rails.groups
Bundler.require(*groups)

module Hyku
  class Application < Rails::Application
    ##
    # @return [String] the URL to use for searching across all tenants.
    #
    # @see .cross_tenant_search_host
    # @see https://github.com/scientist-softserv/palni-palci/issues/947
    def self.cross_tenant_search_url
      # Do not include the scheme (e.g. http or https) but instead let the browser apply the correct
      # scheme.
      "//#{cross_tenant_search_host}/catalog"
    end

    ##
    # @api private
    #
    # @return [String] the host (e.g. "search.hykucommons.org") for cross-tenant search.
    def self.cross_tenant_search_host
      # I'm providing quite a few fallbacks, as this URL is used on the first page you'll see in a
      # new Hyku instance.
      ENV["HYKU_CROSS_TENANT_SEARCH_HOST"].presence ||
      Account.where(search_only: true).limit(1).pluck(:cname)&.first ||
        "search.hykucommons.org"
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Gzip all responses.  We probably could do this in an upstream proxy, but
    # configuring Nginx on Elastic Beanstalk is a pain.
    config.middleware.use Rack::Deflater

    # i18n configuration
    config.i18n.default_locale = :en

    # The locale is set by a query parameter, so if it's not found render 404
    config.action_dispatch.rescue_responses.merge!(
      "I18n::InvalidLocale" => :not_found
    )

    if defined?(ActiveElasticJob) && ENV.fetch('HYRAX_ACTIVE_JOB_QUEUE', '') == 'elastic'
      Rails.application.configure do
        process_jobs = ActiveModel::Type::Boolean.new.cast(ENV.fetch('HYKU_ELASTIC_JOBS', false))
        config.active_elastic_job.process_jobs = process_jobs
        config.active_elastic_job.aws_credentials = lambda { Aws::InstanceProfileCredentials.new }
        config.active_elastic_job.secret_key_base = Rails.application.secrets[:secret_key_base]
      end
    end

    config.to_prepare do
      decorator_paths = [
        File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb"),
        File.join(File.dirname(__FILE__), "../lib/**/*_decorator*.rb")
      ]

      decorator_paths.each do |path|
        Dir.glob(path).sort.each do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
    end

    # OAI additions
    Dir.glob(File.join(File.dirname(__FILE__), "../lib/oai/**/*.rb")).sort.each do |c|
      Rails.configuration.cache_classes ? require(c) : load(c)
    end

    # resolve reloading issue in dev mode
    config.paths.add 'app/helpers', eager_load: true

    config.before_initialize do
      if defined?(ActiveElasticJob) && ENV.fetch('HYRAX_ACTIVE_JOB_QUEUE', '') == 'elastic'
        Rails.application.configure do
          process_jobs = ActiveModel::Type::Boolean.new.cast(ENV.fetch('HYKU_ELASTIC_JOBS', false))
          config.active_elastic_job.process_jobs = process_jobs
          config.active_elastic_job.aws_credentials = lambda { Aws::InstanceProfileCredentials.new }
          config.active_elastic_job.secret_key_base = Rails.application.secrets[:secret_key_base]
        end
      end

      Object.include(AccountSwitch)

      if Settings.bulkrax.enabled
        Bundler.require('bulkrax')
      end
    end


    config.autoload_paths << "#{Rails.root}/app/controllers/api"

    config.after_initialize do

      # Psych Allow YAML Classes
      config.active_record.yaml_column_permitted_classes = [
        ActiveModel::Attribute.const_get(:FromDatabase),
        ActiveSupport::HashWithIndifferentAccess,
        Array,
        Date,
        Hash,
        Symbol,
        Time,
        User
      ]

      ##
      # The first "#valid?" service is the one that we'll use for generating derivatives.
      Hyrax::DerivativeService.services = [
        IiifPrint::TenantConfig::DerivativeService,
        Hyrax::FileSetDerivativesService
      ]

      ##
      # This needs to be in the after initialize so that the IiifPrint gem can do it's decoration.
      #
      # @see https://github.com/scientist-softserv/iiif_print/blob/9e7837ce4bd08bf8fff9126455d0e0e2602f6018/lib/iiif_print/engine.rb#L54 Where we do the override.
      Hyrax::Actors::FileSetActor.prepend(IiifPrint::TenantConfig::FileSetActorDecorator)

      Hyrax::WorkShowPresenter.prepend(IiifPrint::TenantConfig::WorkShowPresenterDecorator)

      ##
      # What the what?  There are bugs in three gems (Bulkrax, Hyrax::DOI, and AllinsonFlex) in
      # which the application's view path is not the first in the view paths.  The result is that
      # those upstream engines's views could be rendered instead of those views defined in the
      # application.
      #
      # TODO: Remove when we're on a version of Bulkrax and Hyrax::DOI that resolves the following
      # PRs:
      #
      # - https://github.com/samvera-labs/bulkrax/pull/855
      # - https://github.com/samvera-labs/allinson_flex/pull/122
      paths = ActionController::Base.view_paths.collect(&:to_s)
      ActionController::Base.view_paths = paths.unshift(Rails.root.join("app/views").to_s).uniq
    end
  end
end
