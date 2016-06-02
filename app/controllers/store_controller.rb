class StoreController < ApplicationController
  
  def index
    @products = Product.published
  end

  def product
    @product = Product.friendly.find(params[:id])
  end
  

  def help
  end
  
end