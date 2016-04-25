class Photo < ApplicationRecord
  acts_as_taggable
  validates :image, presence: true
  
  mount_uploader :image, PhotoUploader
end
