# A Checkout Object handles the interaction between 
# a Cart, a PaymentProcessor, and an Order
# Once up to snuff again, I'll really try to get the session outta here
 
class Checkout
  attr_reader :order, :cart, :session, :processor
  
  def initialize(args)
    @cart = args[:cart]
    @processor = args[:processor]
    @session = args[:session]
  end
  
  def order
    @order ||= create_or_find_from_cart
  end
  
  def pay!
    if processor.requires_confirmation
      processor.process!
    else
      processor.process!
      mark_as_paid
    end
  end
  
  def complete!
    if processor.compelete!
      mark_as_paid
    else
      mark_as_failed
    end
  end
  
  # change name to: prepare_next or rest or something 
  # ie. the checkout needs an object that is cartable
  # but not neccessarily a cart (a basket, or a paper signifying an order)
  # maybe move back into controller??  at least session part
  def remove_cart
    @cart.destroy
    @session[:cart_id] = nil
  end
  
  # same with this, unless you can eliminate and move this back into controller
  def clear_order
    @session[:order_id] = nil
  end
  
  private
  
  def mark_as_paid
    @order.purchased_at = Time.zone.now
    @order.accept_payment!
  end
  
  def mark_as_failed
    @order.purchased_at = nil
    @order.fail_payment!
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
      @order
    else
      @order.errors.add(:base, "Please check quantity available!") if @order
      false
    end     
  end

  # Move this back into Order!
  def find_order_from_cart
    @order = Order.friendly.find(@session[:order_id]) # TODO: dependency to inject
    if @order && @order.updated_at > @cart.updated_at
      @order
    elsif @order && @order.updated_at < @cart.updated_at
      update_order_from_cart
    end
  end
  
  def create_order_from_cart
    transfer_line_items_from_cart_to_order(Order.new) # TODO: dependency to inject?
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

end