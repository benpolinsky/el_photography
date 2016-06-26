class Photo < ApplicationRecord
  attr_accessor :temporary_slug
  include Liquid::Rails::Droppable
  acts_as_taggable
  validates :image, presence: true
  extend FriendlyId
  paginates_per 20
  
  friendly_id :temporary_slug, use: [:slugged, :history]  
  has_one :product
  
  include RankedModel
  ranks :row_order
  
  mount_uploader :image, PhotoUploader
  
  def temporary_slug=(value)
    attribute_will_change!('temporary_slug') if temporary_slug != value
    @temporary_slug = value
  end
  
  def temporary_slug_changed?
    changed.include?('temporary_slug')
  end
  
  def should_generate_new_friendly_id?
    temporary_slug_changed?
  end
  

end
