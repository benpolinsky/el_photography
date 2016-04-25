class Video < ApplicationRecord
  validates :address, presence: true
  acts_as_taggable

end
