class StoreController < ApplicationController
  
  def index
    @products = Product.published
  end

  def product
    @product = Product.friendly.find(params[:id])
    @product_view = ProductView.new(product: @product, cart: @cart)
  end
  

  def help
  end
  
end