# frozen_string_literal: true

# OVERRIDE Bulkrax v5.3.0 to add a geonames lookup for the `based_near` proprerty

module Bulkrax
  module HasMatchersDecorator
    def matched_metadata(multiple, name, result, object_multiple)
      if name == 'based_near'
        result = if result.start_with?('http')
                   Hyrax::ControlledVocabularies::Location.new(RDF::URI.new(result))
                 else
                   geonames_lookup(result)
                 end
      end
      super
    end

    private

      def geonames_lookup(result)
        geonames_username = ::Site.instance.account.geonames_username
        return nil unless geonames_username

        base_url = 'http://api.geonames.org/searchJSON'
        params = { q: result, maxRows: 10, username: geonames_username }
        uri = URI(base_url)
        uri.query = URI.encode_www_form(params)

        response = Net::HTTP.get_response(uri)
        data = JSON.parse(response.body)
        geoname = data['geonames'].first

        unless geoname
          uri = URI::HTTP.build(host: 'fake', fragment: result)
          return Hyrax::ControlledVocabularies::Location.new(RDF::URI.new(uri))
        end

        # Create a Hyrax::ControlledVocabularies::Location object with the RDF subject
        rdf_subject = RDF::URI.new("https://sws.geonames.org/#{geoname['geonameId']}/")
        Hyrax::ControlledVocabularies::Location.new(rdf_subject)
      end
  end
end

# Prepending this to `Bulkrax::HasMatchers` yielded an unbound method
# Thus, I am prepending it to `Bulkrax::Entry` since that mixes in `Bulkrax::HasMatchers`
Bulkrax::Entry.prepend(Bulkrax::HasMatchersDecorator)
