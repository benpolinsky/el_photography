class Photo < ApplicationRecord
  acts_as_taggable
  validates :image, presence: true
  
  include RankedModel
  ranks :row_order
  
  mount_uploader :image, PhotoUploader
end
