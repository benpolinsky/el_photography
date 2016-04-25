class Photo < ApplicationRecord
  acts_as_taggable
  validates :image, presence: true
end
