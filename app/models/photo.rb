class Photo < ApplicationRecord
  acts_as_taggable
  validates :image, presence: true
  extend FriendlyId
  
  friendly_id :caption, use: [:slugged, :history]  
  has_one :product
  
  include RankedModel
  ranks :row_order
  
  mount_uploader :image, PhotoUploader
  

end
