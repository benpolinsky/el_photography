# This Class isn't too bad, there are a few easy pickings...
# The Obvious dependencies are the Paypal and Stripe libraries.
# Instead of subclassing, consider adding the payment method as 
# behavior.  It's also a required behavior... there's no Payment
# without a payment method, Stripe or PayPal
# So we'll make a StripeProcessor and PayPalProcessor that we can
# inject to payment.

class Payment  
  attr_accessor :successful_payment_path, :card, :order
  delegate :url_helpers, to: 'Rails.application.routes'
  
  PAYPAL_OPTIONS = {
    no_shipping: false, 
    allow_note: false, 
    pay_on_paypal: true 
  }
  
  def initialize(args)
    sandbox_mode!
    @order = args[:order]
    @card = args[:card]
    @processor = args[:processor] # we could set Stripe as default...
  end
  
  def process
    payment_response = self.pay
  end
  
  def pay
    # @processor.pay
    self.method("pay_via_#{payment_method}").call
  end
  
  def payment_method
    order.payment_method
  end

  def pay_via_paypal
    begin
      response = paypal_request.setup(paypal_payment_request, ENV['paypal_success_url'], ENV['paypal_cancel_url'], PAYPAL_OPTIONS)
      @successful_payment_path = response.try(:redirect_uri) if response
    rescue Paypal::Exception::APIError => e
      failed!
      
      # TODO: log error if occured 
      # e.message
      # e.response
      # e.response.details
    end    
  end
  
  def failed!
    order.fail_payment!
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
      amount: grand_total
      #:notify_url => '/paypal_notification'
    )
  end
  
  def grand_total
    order.grand_total
  end
  
  def checkout(token, payer_id)
    paypal_request.checkout!(token, payer_id, paypal_payment_request)
  end
  
  def pay_via_stripe
    response = Stripe::Charge.create({
      amount: grand_total.cents,
      currency: "usd",
      source: @card,
      description: "@order.description"
    })
    if response
      @successful_payment_path = url_helpers.payment_accepted_order_path(order)
      true
    else
      failed!
    end
  end
  
  def successful?
    pay
  end
  
  def complete_paypal(token, payer_id)
    info = checkout(token, payer_id).payment_info
    if info.first.payment_status == "Completed"
      true
    else
      failed!
    end
  end
  
  private
  
  def sandbox_mode!
    Paypal.sandbox!
  end
end