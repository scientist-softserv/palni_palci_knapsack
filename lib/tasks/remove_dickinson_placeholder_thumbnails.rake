namespace :hyku do
  desc "Remove Hyku Commons placeholder file sets from tenant"
  task remove_placeholder_file_sets: :environment do
    # The original ask was for the Dickinson tenant, but passing in an ENV var would be useful for testing
    # example:
    # ```sh
    # REMOVE_PLACEHOLDER_FILE_SETS_FROM="dev.hyku.test" rake hyku:remove_placeholder_file_sets
    # ```
    account_cname = ENV['REMOVE_PLACEHOLDER_FILE_SETS_FROM'] || "dickinson.hykucommons.org"

    Account.find_each do |account|
      next unless account.cname == account_cname

      begin
        switch!(account.cname)
        puts "********************** switched to #{account.cname} **********************"

        file_set_titles = ["HykuCommonsPlaceholder.pdf", "hykuplaceholderarchives.pdf"]
        query = file_set_titles.map { |title| "title_tesim:\"#{title}\"" }.join(" OR ")
        file_sets = FileSet.where(query)
        file_sets.each { |file_set| file_set.destroy(eradicate: true) }
      rescue StandardError => e
        puts "********************** error: #{e} **********************"
        next
      end
    end
  end
end
