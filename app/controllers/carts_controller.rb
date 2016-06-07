class CartsController < ApplicationController
  def add_item
    @cart_item = @cart.add_cart_item(product_or_variant_id, cart_item_params[:product_type])
    @cart_items = @cart.line_items
    @cart_quantity = @cart.number_of_items
    @product = @cart_item.product

    
    respond_to do |format|
      if @cart_item.save
        @cart.reload
        format.html {redirect_back(fallback_location: store_path, notice: "Item Added to Cart!")}
        format.js 
      else
        @resource = @cart_item
        format.html {redirect_back(fallback_location: store_path, notice: "Whoops something went wrong!")}
        format.js
      end
    end
  end
  
  def increase_item_quantity
    @cart_item = @cart.line_items.find(params[:item_id])
    @cart_item.increment_quantity
    @new_quantity = @cart_item.quantity
    @cart_item.save unless @cart_item.frozen?
    @cart.save
    @cart.reload
    @cart_quantity = @cart.number_of_items
    @product = @cart_item.product
    @cart_items = @cart.line_items
    render :change_item_quantity
  end
  
  def decrease_item_quantity
    @cart_item = @cart.line_items.find(params[:item_id])
    @cart_item.decrement_quantity
    @cart.empty! if @cart.line_items.count == 0
    @new_quantity = @cart_item.quantity
    @cart_item.save unless @cart_item.frozen?
    @cart.save
    @cart.reload
    @cart_quantity = @cart.number_of_items
    @product = @cart_item.product
    @cart_items = @cart.line_items
    render :change_item_quantity
  end
  
  
  def show
      
  end
  
  def empty
    @cart.empty_contents
    respond_to do |format|
      format.html {redirect_back(fallback_location: store_path, notice: "Cart Emptied")}
      format.js
    end

  end
  
  private
  
  def product_or_variant_id
    cart_item_params[:product_id].present? ? cart_item_params[:product_id] : cart_item_params[:variant_id]
  end
  
  def cart_item_params
    params.require(:line_item).permit(:product_id, :product_type, :quantity, :variant_id)
  end
end