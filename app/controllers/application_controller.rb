class ApplicationController < ActionController::Base
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
end
