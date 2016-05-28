class StoreController < ApplicationController
  
  def index
    @products = Product.published
  end

  def product
  end
  

  def help
  end
  
  private
  def find_model
    @model = Shop.find(params[:id]) if params[:id]
  end
end