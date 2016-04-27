class Video < ApplicationRecord
  validates :address, presence: true
  acts_as_taggable


  def video_id
    if is_vimeo?
      address.match(/\/(\d+)/)[1]
    else
      address.match(/(?<=v=)(.+)/)[1]
    end
  end
  
  private
  
  def is_vimeo?
    address.include? "vimeo"
  end
end
