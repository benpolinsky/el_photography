class Photo < ApplicationRecord
  include Liquid::Rails::Droppable
  acts_as_taggable
  validates :image, presence: true
  extend FriendlyId
  
  friendly_id :caption, use: [:slugged, :history]  
  has_one :product
  
  include RankedModel
  ranks :row_order
  
  mount_uploader :image, PhotoUploader
  
  def should_generate_new_friendly_id?
    caption_changed? && caption_was.present? 
  end
  

end
