# frozen_string_literal: true

# OVERRIDE ability to download files when the site disallows downloads.
module AbilityDecorator
  def test_download(*args)
    if (Site.account.settings[:allow_downloads].nil? || Site.account.settings[:allow_downloads].to_i.nonzero?
      super
    else
      false
  end
end

Ability.prepend(AbilityDecorator)
