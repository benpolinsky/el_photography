class Video < ApplicationRecord
  validates :address, presence: true
  acts_as_taggable
  
  include RankedModel
  ranks :row_order


  def video_id
    if is_vimeo?
      address.match(/\/(\d+)/)[1]
    else
      address.match(/(?<=v=)(.+)/)[1]
    end
  end
  
  def embed_address
    if is_vimeo?
      "https://player.vimeo.com/video/#{video_id}"
    else
      "https://www.youtube.com/embed/#{video_id}"
    end
  end
  
  def image_url
    if is_vimeo?
     vimeo_json["thumbnail_url"]
    else
      "http://img.youtube.com/vi/#{video_id}/hqdefault.jpg"
    end
  end
  
  private
  
  def is_vimeo?
    address.include? "vimeo"
  end
  
  def vimeo_json
    JSON.load(open("https://vimeo.com/api/oembed.json?url=https%3A//vimeo.com/#{video_id}"))
  end
end
