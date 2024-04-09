# frozen_string_literal: true

# OVERRIDE: sort collections
module FeaturedCollectionListDecorator
  def featured_collections
    return @collections if @collections
    @collections = super

    sort_by_title! unless manually_ordered?
    @collections
  end

  private

  def manually_ordered?
    !@collections.all? { |c| c.order == FeaturedCollection.feature_limit }
  end

  def sort_by_title!
    @collections.sort_by! { |c| c.presenter.title.first.downcase }
  end
end

FeaturedCollectionList.prepend(FeaturedCollectionListDecorator)
