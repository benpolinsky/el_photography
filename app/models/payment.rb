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
  
  def receive_paypal_ipn
  end
  
  def receive_stripe_webhook
  end
  
  def successful?
    pay
  end
  
  def confirmed?
    @order.payment_method == 'paypal' ? receive_paypal_ipn : receive_stripe_webhook
  end
end