# # frozen_string_literal: true

# Use this to override any Hyrax configuration from the Knapsack
Hyrax.config do |config|
  # TODO: Valkyrize models and update this initializer
  # Injected via `rails g hyrax:work Oer`
  # config.register_curation_concern :oer
  # Injected via `rails g hyrax:work Etd`
  config.register_curation_concern :etd
  # # Injected via `rails g hyrax:work Cdl`
  # config.register_curation_concern :cdl

  # # See https://github.com/scientist-softserv/adventist-dl/issues/183
  # # Also, we will continue to extract txt file's text using Adventist::TextFileTextExtractionService
  # config.extract_full_text = false
  # config.work_requires_files = false

  # # Location autocomplete uses geonames to search for named regions.
  # # Specify the user for connecting to geonames:
  # # Register here: http://www.geonames.org/manageaccount
  # config.geonames_username = ENV.fetch('HYKU_GEONAMES_USERNAME', 'scientist')
  # # If you have ffmpeg installed and want to transcode audio and video uncomment this line
  # config.enable_ffmpeg = false

  # config.branding_path = ENV.fetch('HYRAX_BRANDING_PATH', Rails.root.join('public', 'branding'))
end