# A Checkout Object handles:
# initiating new orders,
# saving orders,
# finding and continuing stray orders
# ensuring an order progresses in the right order.
# cancelling orders
# emptying carts
# initiating payments
# handing successful or unsuccessful payments
# giving out reciepts

class Checkout 
  def initialize(cart, order=nil)
    @cart = cart
    @order = order
    @order ||= Order.new_from_cart(cart)
  end
  
  
end