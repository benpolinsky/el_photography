class NullPhoto 
  include Liquid::Rails::Droppable
  def image(size=nil)
    ActionController::Base.helpers.asset_path("fallback/" + [size, "default.png"].compact.join('_'))
  end
  
  def image_url(size=nil)
    image(size)
  end
  
  def persisted?
    false
  end
  
  def id
    0
  end
end