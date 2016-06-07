class StripePaymentProcessor
  attr_reader :card, :description, :amount_to_pay, :requires_confirmation
  
  def initialize(args)
    @card = args[:card]
    @amount_to_pay = args[:amount_to_pay]
    @description = args[:description]
    @requires_confirmation = false # now I'm not checking type (StripeProcessor), but behavior
  end
  
  def process!
    if payment_request
      true
    else
      false
    end
  end
  
  private 
  
  def payment_request
    Stripe::Charge.create({
      amount: amount_to_pay.cents,
      currency: "usd",
      source: card,
      description: description
    })
  end
  
end