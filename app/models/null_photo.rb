class NullPhoto
  def image
    ActionController::Base.helpers.image_path("fallback/default.png");
  end
  
  def image_url(version)
    image
  end
end