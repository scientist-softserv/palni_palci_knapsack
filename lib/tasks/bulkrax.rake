# frozen_string_literal: true
namespace :bulkrax do
  desc "reclassify OerCsvParser's and EtdCsvParser's to CsvParser's"
  task single_csv_parser: :environment do
    Account.find_each do |account|
      puts "=============== updating #{account.name} ============"
      next if account.name == "search"
      switch!(account)

      begin
        Bulkrax::Exporter.find_each do |e|
          e.update(parser_klass: 'Bulkrax::CsvParser') if e.parser_klass == 'Bulkrax::OerCsvParser' || e.parser_klass == 'Bulkrax::EtdCsvParser'
        end
        Bulkrax::Importer.find_each do |e|
          e.update(parser_klass: 'Bulkrax::CsvParser') if e.parser_klass == 'Bulkrax::OerCsvParser' || e.parser_klass == 'Bulkrax::EtdCsvParser'
        end
        puts "=============== finished updating #{account.name} ============"
      rescue => e
        puts "(#{e.message})"
      end
    end
  end
end
