class NullPhoto 
  include Liquid::Rails::Droppable
  def image
    ActionController::Base.helpers.image_path("fallback/default.png");
  end
  
  def image_url(size=nil)
    image
  end
end