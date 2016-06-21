class PhotoDrop < Liquid::Rails::Drop
  attributes :image_url, :image, :caption
  
  belongs_to :product
  
  
  def thumb
    image.thumb.url
  end
  
  def medium
    image.medium.url
  end
  
  def large
    image.main.url
  end

  
end

class NullPhotoDrop < PhotoDrop
  def thumb
    image
  end
  
  def medium
    image
  end
  
  def large
    image
  end
end