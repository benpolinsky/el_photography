# A Checkout Object handles:
# initiating new orders,
# saving orders,
# finding and continuing stray orders
# ensuring an @order progresses in the right @order.
# cancelling orders
# emptying carts
# initiating payments
# handing successful or unsuccessful payments
# giving out reciepts

class Checkout
  attr_reader :order
  def initialize(cart, session)
    @cart = cart
    @session = session
    create_or_find_from_cart
  end
  
  def create_or_find_from_cart
    # if this is a user-based system, 
    # we'd want to fetch a user's latest order
    # and compare it's updated_at to the cart's updated_at
    
    # for now, we'll just store the last order_id in the session
    # since a user has no way of picking up an @order on a different
    # computer/browser
    
    @order = find_order_from_cart if @session[:order_id]
    @order ||= create_order_from_cart
    if @order && @order.line_items.any?
      @order.skip_email_validation = true
      @order.save
    else
      @order.errors.add(:base, "Please check quantity available!") if @order
      false
    end     
  end

  def find_order_from_cart
    @order = Order.find(@session[:order_id])
    if @order && @order.updated_at > @cart.updated_at
      @order
    elsif @order && @order.updated_at < @cart.updated_at
      update_order_from_cart
    end
  end
  
  def create_order_from_cart
    transfer_line_items_from_cart_to_order(Order.new)
  end
  
  def update_order_from_cart
    @order.line_items.delete_all
    transfer_line_items_from_cart_to_order(@order)
  end
  
  def transfer_line_items_from_cart_to_order(order)
    @cart.line_items.each do |item|
      new_item = item.dup
      new_item.itemized = order
      new_item.quantity = item.quantity
      order.line_items << new_item
    end
    order
  end
  
  def remove_cart
    @cart.destroy
    @session[:cart_id] = nil
  end
  
  def clear_order
    @session[:order_id] = nil
  end
end