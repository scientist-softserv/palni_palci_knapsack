# Hyrax Override: Improve Citations Format
# frozen_string_literal: true

module Hyrax
  module CitationsBehaviors
    module Formatters
      class MlaFormatter < BaseFormatter
        include Hyrax::CitationsBehaviors::PublicationBehavior
        include Hyrax::CitationsBehaviors::TitleBehavior

        def format(work)
          text = ''

          # setup formatted author list
          authors = author_list(work).reject(&:blank?)
          text += "<span class=\"citation-author\">#{format_authors(authors)}</span>"
          # setup title
          title_info = setup_title_info(work)
          text += format_title(title_info)

          # Hyrax Override: adds contributor
          text += " #{work.contributor.join(', ')}." if work.contributor.present?

          # Publication
          pub_info = clean_end_punctuation(setup_pub_info(work, true))
          text += "<span class=\"citation-publication-info\">#{pub_info}. </span>" if pub_info.present?
          # text += (pub_info + ".") if pub_info.present?

          # Hyrax Override: adds addtl content for citation
          # text += add_link_to_original(work)
          text += " <span class='citation-link'>#{add_link_to_original(work)}</span>"
          # end

          text.html_safe
        end

        def format_authors(authors_list = [])
          return "" if authors_list.blank?
          authors_list = Array.wrap(authors_list)
          text = concatenate_authors_from(authors_list)
          if text.present?
            text += "." unless text.end_with?(".")
            text += " "
          end
          text
        end

        def concatenate_authors_from(authors_list)
          text = ''
          text += authors_list.first
          if authors_list.length > 1
            if authors_list.length < 4
              authors_list[1...-1].each do |author|
                text += ", #{author}"
              end
              text += ", and #{authors_list.last}"
            else
              text += ", et al"
            end
          end
          text
        end
        private :concatenate_authors_from

        def format_date(pub_date)
          " #{pub_date.join(', ')}."
        end

        def format_title(title_info)
          title_info.blank? ? "" : "<i class=\"citation-title\">#{mla_citation_title(title_info)}</i> "
        end
      end
    end
  end
end
