class CartsController < ApplicationController
  def add_item
    @cart_item = @cart.add_cart_item(product_or_variant_id, cart_item_params[:product_type])
    @cart_items = @cart.line_items
    @cart_quantity = @cart.number_of_items
    @product = @cart_item.product
    
    respond_to do |format|
      if @cart_item.save
        format.html {redirect_to :back, notice: "Item Added to Cart!"}
        format.js 
      else
        format.html { redirect_to :back, notice: "Whoops something went wrong!" }
        format.js
      end
    end
  end
  
  
  def show
      
  end
  
  private
  
  def product_or_variant_id
    cart_item_params[:product_id].present? ? cart_item_params[:product_id] : cart_item_params[:variant_id]
  end
  
  def cart_item_params
    params.require(:line_item).permit(:product_id, :product_type, :quantity, :variant_id)
  end
end