# A Checkout Object further standardizes PaymentProcessor
# Perhaps I've stripped away too much responsibility..
 
class Checkout
  attr_reader :processor
  
  def initialize(args)
    @processor = args[:processor]
  end
  
  def pay!
    processor.process!
  end
  
  def complete!(args)
    processor.complete!(args)
  end

  def finish
    @cart.destroy
  end
  
  # TODO: rename to restart
  # same with this, unless you can eliminate and move this back into controller
  def clear_order
    @session[:order_id] = nil
  end
  
  
  

end