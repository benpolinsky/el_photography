class Payment
  def initialize(order)
    @order = order
  end
  
  def pay
    self.method("pay_via_#{@order.payment_method}").call
  end
  
  def pay_via_paypal

  end
  
  def pay_via_stripe
  end
  
  def successful?
    pay
  end
end