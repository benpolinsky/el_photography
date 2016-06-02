class Payment  
  attr_accessor :successful_payment_path, :card
  delegate :url_helpers, to: 'Rails.application.routes'
  
  PAYPAL_OPTIONS = {
    no_shipping: true, # if you want to disable shipping information
    allow_note: false, # if you want to disable notes
    pay_on_paypal: true # if you don't plan on showing your own confirmation step
  }
  
  def initialize(order, card = nil)
    Paypal.sandbox!
    @order = order
    @card = card
  end
  
  def process
    payment_response = self.pay
  end
  
  def pay
    self.method("pay_via_#{@order.payment_method}").call
  end

  def pay_via_paypal
    begin
      response = paypal_request.setup(paypal_payment_request, 'http://localhost:3000/store/orders/success', 'http://localhost:3000/store/orders/cancel', PAYPAL_OPTIONS)
      if response
        @successful_payment_path = response.try(:redirect_uri)
      else
        false
      end
    rescue Paypal::Exception::APIError => e
      p e.message
      p e.response
      p e.response.details
    end    
  end
  
  def paypal_request
    Paypal::Express::Request.new(
      username: ENV['paypal_username'],
      password: ENV['paypal_password'],
      signature: ENV['paypal_signature']
    )
  end
  
  def paypal_payment_request
    Paypal::Payment::Request.new(
      description: "@order.description",
      amount: @order.grand_total
      #:notify_url => '/paypal_notification'
    )
  end
  
  def checkout(token, payer_id)
    paypal_request.checkout!(token, payer_id, paypal_payment_request)
  end
  
  def pay_via_stripe
    response = Stripe::Charge.create({
      amount: @order.grand_total_cents,
      currency: "usd",
      source: @card,
      description: "@order.description"
    })
    if response
      @successful_payment_path = url_helpers.payment_accepted_order_path(@order)
      true
    else
      # error checking
    end
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