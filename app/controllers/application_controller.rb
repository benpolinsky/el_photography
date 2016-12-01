class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :find_cart
  before_action :determine_browser
  before_action :grab_facebook_image
  
  def grab_facebook_image
    @tag = ActsAsTaggableOn::Tag.friendly.find('berries')
    @taggings = ActsAsTaggableOn::Tagging.where(tag_id: @tag.id).rank(:row_order)
    @facebook_image = @taggings.first.taggable
  end
  
  def find_cart
    @cart = Cart.includes(line_items: :itemized).find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Cart.create
      session[:cart_id] = @cart.id
    ensure
      @cart_view = CartView.new(@cart)
  end
  
  def error_list_for(model)
    # doesn't account for associated models...
    model.errors.full_messages.join(", ")
  end
  
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || admin_root_path
  end
  
  def determine_browser
    @mobile = true if (browser.device.mobile? || browser.device.tablet?)
  end


end
