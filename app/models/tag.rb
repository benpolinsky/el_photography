# quick n dirty - open em up
ActsAsTaggableOn::Tag.class_eval do
  attr_accessor :temporary_slug
  include Liquid::Rails::Droppable
  include RankedModel
  ranks :row_order
  
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]  
  scope :next, -> id {where("id > ?", id).order("id ASC")}
  scope :previous, -> id {where("id < ?", id).order("id DESC")}
end



# quick n dirty - open em up
class ActsAsTaggableOn::Tag
  def temporary_slug=(value)
    attribute_will_change!('temporary_slug') if temporary_slug != value
    @temporary_slug = value
  end
  
  def should_generate_new_friendly_id?
    temporary_slug_changed?
  end
  
  def temporary_slug_changed?
    changed.include?('temporary_slug')
  end
 
  
  def next
    ActsAsTaggableOn::Tag.next(self.id).first
  end
  
  def previous
    ActsAsTaggableOn::Tag.previous(self.id).first
  end
  
  def slug_candidates
    [
      :temporary_slug,
      :name,
      [:temporary_slug, :id]
    ]
  end
end



# lil wrapper 
module Tag

  TAG = ActsAsTaggableOn::Tag

  def self.assets_for_tag(tag)
    tag.taggings.order(:row_order).map(&:taggable)
  end
  
  def self.assets_for_tag_with_images(tag)
    assets_for_tag(tag).map{|i|i.image_url(:main)}
  end
  
  def self.first_asset_for_tag_with_image(tag)
    assets_for_tag_with_images(tag).first
  end

  def self.first_photo_for(tag)
    tag.taggings.map{|t| t.taggable.image_url}.first
  end

  def self.all_tagged_models(tag)
    tag.taggings.map(&:taggable)
  end

  def self.first
    TAG.first
  end
  
  def self.last(num=nil)
    TAG.last(num)
  end
  
  def self.first_or_initialize(params={})
    TAG.first_or_initialize(params)
  end
  
  def self.all
    TAG.all
  end
  
  def self.plus_one
    all + [Tag.new_tag]
  end
  
  def self.new_tag(params={})
    TAG.new(params)
  end
  
  def self.create(params={})
    TAG.create(param)
  end

  def self.list
    all.map(&:name).join(", ")
  end
  
  def self.latest
    all.includes(:taggings).order("taggings.created_at ASC")
  end
  
  def self.by_position
    all.includes(:taggings).rank(:row_order)
  end

end