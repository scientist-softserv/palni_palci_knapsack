# frozen_string_literal: true

module HykuKnapsack
  module Steps
    class AddCustomRelations
      include Dry::Monads[:result]

      def call(change_set)
        if change_set.model.is_a?(OerResource)
debugger
          attributes_collection = change_set.attributes.dup.delete(:related_members_attributes)
          add_custom_relations(change_set, attributes_collection)
        end

        Success(change_set)
      rescue NoMethodError => err
        Failure([err.message, change_set])
      end

      private

      # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      def add_custom_relations(change_set, attributes_collection)
debugger
        return change_set unless attributes_collection
        attributes = attributes_collection&.sort_by { |i, _| i.to_i }&.map { |_, attrs| attrs }

        # checking for existing works to avoid rewriting/loading works that are already attached
        existing_previous_works = change_set.curation_concern.previous_version_id
        existing_newer_works = change_set.curation_concern.newer_version_id
        existing_alternate_works = change_set.curation_concern.alternate_version_id
        existing_related_items = change_set.curation_concern.related_item_id

        attributes&.each do |attrs|
          next if attrs['id'].blank?
          if existing_previous_works&.include?(attrs['id']) ||
             existing_newer_works&.include?(attrs['id']) ||
             existing_alternate_works&.include?(attrs['id']) ||
             existing_related_items&.include?(attrs['id'])

            if existing_previous_works&.include?(attrs['id'])
              change_set = remove(change_set, attrs['id'], attrs['relationship']) if
                ActiveModel::Type::Boolean.new.cast(attrs['_destroy']) && attrs['relationship'] == 'previous-version'
            elsif existing_newer_works&.include?(attrs['id'])
              change_set = remove(change_set, attrs['id'], attrs['relationship']) if
              ActiveModel::Type::Boolean.new.cast(attrs['_destroy']) && attrs['relationship'] == 'newer-version'
            elsif existing_alternate_works&.include?(attrs['id'])
              change_set = remove(change_set, attrs['id'], attrs['relationship']) if
              ActiveModel::Type::Boolean.new.cast(attrs['_destroy']) && attrs['relationship'] == 'alternate-version'
            elsif existing_related_items&.include?(attrs['id'])
              change_set = remove(change_set, attrs['id'], attrs['relationship']) if
              ActiveModel::Type::Boolean.new.cast(attrs['_destroy']) && attrs['relationship'] == 'related-item'
            end
          else
            change_set = add(change_set, attrs['id'], attrs['relationship'])
          end
        end
        change_set
      end

      def add(change_set, id, relationship)
debugger
        rel = "#{relationship.underscore}_id"
        case rel
        when "previous_version_id"
          change_set.curation_concern.previous_version_id = (change_set.curation_concern.previous_version_id.to_a << id)
        when "newer_version_id"
          change_set.curation_concern.newer_version_id = (change_set.curation_concern.newer_version_id.to_a << id)
        when "alternate_version_id"
          change_set.curation_concern.alternate_version_id = (change_set.curation_concern.alternate_version_id.to_a << id)
        when "related_item_id"
          change_set.curation_concern.related_item_id = (change_set.curation_concern.related_item_id.to_a << id)
        end
        change_set.curation_concern.save
        change_set
      end

      def remove(change_set, id, relationship)
debugger
        rel = "#{relationship.underscore}_id"
        case rel
        when "previous_version_id"
          change_set.curation_concern.previous_version_id = (change_set.curation_concern.previous_version_id.to_a - [id])
        when "newer_version_id"
          change_set.curation_concern.newer_version_id = (change_set.curation_concern.newer_version_id.to_a - [id])
        when "alternate_version_id"
          change_set.curation_concern.alternate_version_id = (change_set.curation_concern.alternate_version_id.to_a - [id])
        when "related_item_id"
          change_set.curation_concern.related_item_id = (change_set.curation_concern.related_item_id.to_a - [id])
        end
        change_set.curation_concern.save
        change_set
      end
    end
  end
end
