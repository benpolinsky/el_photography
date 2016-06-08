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

end