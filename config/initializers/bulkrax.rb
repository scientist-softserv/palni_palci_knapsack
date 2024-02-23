# frozen_string_literal: true

require 'bagit'

Bulkrax.setup do |config|
  # Add or remove local parsers
  config.parsers -= [
    { name: "OAI - Dublin Core", class_name: "Bulkrax::OaiDcParser", partial: "oai_fields" },
    { name: "OAI - Qualified Dublin Core", class_name: "Bulkrax::OaiQualifiedDcParser", partial: "oai_fields" },
    { name: "XML", class_name: "Bulkrax::XmlParser", partial: "xml_fields" }
  ]

  # Field to use during import to identify if the Work or Collection already exists.
  # Default is 'source'.
  # config.system_identifier_field = 'source'

  # WorkType to use as the default if none is specified in the import
  # Default is the first returned by Hyrax.config.curation_concerns
  # config.default_work_type = MyWork

  # Path to store pending imports
  # config.import_path = 'tmp/imports'

  # Path to store exports before download
  # config.export_path = 'tmp/exports'

  # Server name for oai request header
  # config.server_name = 'my_server@name.com'

  # Field_mapping for establishing a parent-child relationship (FROM parent TO child)
  # This can be a Collection to Work, or Work to Work relationship
  # This value IS NOT used for OAI, so setting the OAI Entries here will have no effect
  # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
  # Example:
  #   {
  #     'Bulkrax::RdfEntry'  => 'http://opaquenamespace.org/ns/contents',
  #     'Bulkrax::CsvEntry'  => 'children'
  #   }
  # By default no parent-child relationships are added
  # config.parent_child_field_mapping = { }

  # Field_mapping for establishing a collection relationship (FROM work TO collection)
  # This value IS NOT used for OAI, so setting the OAI parser here will have no effect
  # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
  # The default value for CSV is collection
  # Add/replace parsers, for example:
  # config.collection_field_mapping['Bulkrax::RdfEntry'] = 'http://opaquenamespace.org/ns/set'

  config.fill_in_blank_source_identifiers = ->(obj, index) { "#{Site.instance.account.name}-#{obj.importerexporter.id}-#{index}" }

  # Field mappings
  parser_mappings = {
    'abstract' => { from: ['abstract'], split: '\|', generated: true },
    'accessibility_feature' => { from: ['accessibility_feature'], split: '\|' },
    'accessibility_hazard' => { from: ['accessibility_hazard'], split: '\|' },
    'accessibility_summary' => { from: ['accessibility_summary'] },
    'additional_information' => { from: ['additional_information'], split: '\|', generated: true },
    'admin_set_id' => { from: ['admin_set_id'], generated: true },
    'alternate_version' => { from: ['alternate_version'], split: '\|' },
    'alternative_title' => { from: ['alternative_title'], split: '\|', generated: true },
    'arkivo_checksum' => { from: ['arkivo_checksum'], split: '\|', generated: true },
    'audience' => { from: ['audience'], split: '\|' },
    'based_near' => { from: ['location'], split: '\|' },
    'bibliographic_citation' => { from: ['bibliographic_citation'], split: '\|', generated: true },
    'bulkrax_identifier' => { from: ['source_identifier'], source_identifier: true, generated: true },
    'children' => { from: ['children'], split: /\s*[;|]\s*/, related_children_field_mapping: true },
    'chronology_note' => { from: ['chronology_note'], split: '\|' },
    'committee_member' => { from: ['committee_member'], split: '\|' },
    'contributing_library' => { from: ['contributing_library'], split: '\|' },
    'contributor' => { from: ['contributor'], split: '\|' },
    'creator' => { from: ['author', 'creator'], split: '\|' },
    'date_created' => { from: ['date', 'date_created'], split: '\|' },
    'date_uploaded' => { from: ['date_uploaded'], generated: true },
    'date' => { from: ['date'], split: '\|' },
    'degree_discipline' => { from: ['discipline'], split: '\|' },
    'degree_grantor' => { from: ['grantor'], split: '\|' },
    'degree_level' => { from: ['level'], split: '\|' },
    'degree_name' => { from: ['degree'], split: '\|' },
    'depositor' => { from: ['depositor'], split: '\|', generated: true },
    'description' => { from: ['description'], split: '\|' },
    'discipline' => { from: ['discipline'], split: '\|' },
    'education_level' => { from: ['education_level'], split: '\|' },
    'embargo_id' => { from: ['embargo_id'], generated: true },
    'file' => { from: ['item'], split: '\|' },
    'identifier' => { from: ['identifier'], split: '\|' },
    'import_url' => { from: ['import_url'], split: '\|', generated: true },
    'keyword' => { from: ['keyword'], split: '\|' },
    'label' => { from: ['label'], generated: true },
    'language' => { from: ['language'], split: '\|' },
    'learning_resource_type' => { from: ['learning_resource_type'], split: '\|' },
    'lease_id' => { from: ['lease_id'], generated: true },
    'library_catalog_identifier' => { from: ['library_catalog_identifier'], split: '\|' },
    'license' => { from: ['license'], split: '\|' },
    'newer_version' => { from: ['newer_version'], split: '\|' },
    'oer_size' => { from: ['oer_size'], split: '\|' },
    'on_behalf_of' => { from: ['on_behalf_of'], generated: true },
    'owner' => { from: ['owner'], generated: true },
    'parents' => { from: ['parents'], split: /\s*[;|]\s*/, related_parents_field_mapping: true },
    'previous_version' => { from: ['previous_version'], split: '\|' },
    'proxy_depositor' => { from: ['proxy_depositor'], generated: true },
    'publisher' => { from: ['publisher'], split: '\|' },
    'related_item' => { from: ['related_item'], split: '\|' },
    'related_url' => { from: ['related_url', 'relation'], split: '\|' },
    'relative_path' => { from: ['relative_path'], split: '\|', generated: true },
    'rendering_ids' => { from: ['rendering_ids'], split: '\|', generated: true },
    'representative_id' => { from: ['representative_id'], generated: true },
    'resource_type' => { from: ['type'], split: '\|' },
    'rights_holder' => { from: ['rights_holder'], split: '\|' },
    'rights_notes' => { from: ['rights_notes'], split: '\|', generated: true },
    'rights_statement' => { from: ['rights', 'rights_statement'], split: '\|', generated: true },
    'source' => { from: ['source'], split: '\|', generated: true },
    'state' => { from: ['state'], generated: true },
    'subject' => { from: ['subject'], split: '\|' },
    'table_of_contents' => { from: ['table_of_contents'], split: '\|' },
    'title' => { from: ['title'], split: '\|' },
  }

  config.field_mappings['Bulkrax::BagitParser'] = parser_mappings
  config.field_mappings['Bulkrax::CsvParser'] = parser_mappings.merge(
    {'video_embed' => { from: ['video_embed'] }}
    )

  # Add to, or change existing mappings as follows
  #   e.g. to exclude date
  #   config.field_mappings["Bulkrax::OaiDcParser"]["date"] = { from: ["date"], excluded: true }

  # To duplicate a set of mappings from one parser to another
  #   config.field_mappings["Bulkrax::OaiOmekaParser"] = {}
  #   config.field_mappings["Bulkrax::OaiDcParser"].each {|key,value| config.field_mappings["Bulkrax::OaiOmekaParser"][key] = value }

  # Properties that should not be used in imports/exports. They are reserved for use by Hyrax.
  # config.reserved_properties += ['my_field']

  # Sidebar for hyrax 3+ support
  if Object.const_defined?(:Hyrax) && ::Hyrax::DashboardController&.respond_to?(:sidebar_partials)
    Hyrax::DashboardController.sidebar_partials[:repository_content] << "hyrax/dashboard/sidebar/bulkrax_sidebar_additions"
  end
end
