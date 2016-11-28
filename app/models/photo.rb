class Photo < ApplicationRecord
  attr_accessor :temporary_slug, :absolute_position
  include Liquid::Rails::Droppable
  acts_as_taggable
  validates :image, presence: true
  extend FriendlyId
  paginates_per 20
  
  friendly_id :temporary_slug, use: [:slugged, :history]  

  # has_one :product
  belongs_to :photoable, polymorphic: true, optional: true
  
  include RankedModel
  
  ranks :row_order
  
  default_scope { order(row_order: :asc) } 
  
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
  
  def purchasable?
    photoable_type == 'Product' && photoable.try(:published?)
  end
  
  def self.unassociated
    where(photoable_type: nil)
  end
  
  def self.not_variants
    where("photoable_type IS NULL OR photoable_type != ?", 'Variant')
  end

  def self.with_absolute_position
    # Inefficient: I'll turn to sql later
    includes(:taggings).rank(:row_order)
  end
end
