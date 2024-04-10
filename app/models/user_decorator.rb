# frozen_string_literal: true

module UserDecorator
  extend ActiveSupport::Concern

  class_methods do
    def from_omniauth(auth)
      u = find_by(provider: auth.provider, uid: auth.uid)
      return u if u

      u = find_by(email: auth&.info&.email&.downcase)
      u ||= new
      u.provider = auth.provider
      u.uid = auth.uid
      u.email = auth&.info&.email
      u.email ||= auth.uid
      # rubocop:disable Performance/RedundantMatch
      u.email = [auth.uid, '@', Site.instance.account.email_domain].join unless u.email.match('@')
      # rubocop:enable Performance/RedundantMatch

      # Passwords are required for all records, but in the case of OmniAuth,
      # we're relying on the other auth provider.  Hence we're creating a random
      # password.
      u.password = Devise.friendly_token[0, 20] if u.new_record?

      # assuming the user model has a name
      u.display_name = auth&.info&.name
      u.display_name ||= "#{auth&.info&.first_name} #{auth&.info&.last_name}" if auth&.info&.first_name && auth&.info&.last_name
      u.save
      u
    end
  end
end

User.alias is_superadmin superadmin?
User.alias is_superadmin= superadmin=
User.attr_accessible :email, :password, :password_confirmation if Blacklight::Utils.needs_attr_accessible?

User.prepend(UserDecorator)
