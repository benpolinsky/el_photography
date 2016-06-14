class Video < ApplicationRecord
  validates_presence_of :address
  acts_as_taggable
  
  include RankedModel
  ranks :row_order
  extend FriendlyId

  friendly_id :video_id, use: [:slugged, :history]
  validates_presence_of :video_id

  def video_id
    return unless address.present?
    if is_vimeo?
      address.match(/\/(\d+)/).try(:[], 1)
    else
      address.match(/(?<=v=)(.+)/).try(:[], 1)
    end
  end
  
  def embed_address
    if is_vimeo?
      "https://player.vimeo.com/video/#{video_id}"
    else
      "https://www.youtube.com/embed/#{video_id}"
    end
  end
  
  def image_url(size=nil)
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
