class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :find_cart
  
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
  
  protected
   def authenticate_user!
     if user_signed_in?
       super
     else
       redirect_to coming_soon_path, :notice => 'if you want to add a notice'
       ## if you want render 404 page
       ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
     end
   end
end
