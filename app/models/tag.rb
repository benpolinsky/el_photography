# little wrapper module for tags
ActsAsTaggableOn::Tag.class_eval do
  include RankedModel
  ranks :row_order
  
  extend FriendlyId
  friendly_id :name, use: :slugged
end
module Tag
  
  TAG = ActsAsTaggableOn::Tag

  def self.assets_for_tag(tag)
    tag.taggings.map(&:taggable)
  end
  
  def self.assets_for_tag_with_images(tag)
    assets_for_tag(tag).map{|i|i.image_url(:medium)}
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

end