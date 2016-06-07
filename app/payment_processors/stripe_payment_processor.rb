class StripePaymentProcessor
  attr_reader :card, :description, :amount_to_pay, :requires_confirmation
  
  def initialize(args)
    @card = args[:card]
    @amount_to_pay = args[:amount_to_pay]
    @description = args[:description] || ""
    @requires_confirmation = false 
    raise ArgumentError if [card, amount_to_pay].any?(&:blank?)
  end
  
  def process!
    payment_request
  end
  
  def payment_successful?
    payment_request[:status] == "succeeded"
  end
  
  private 
  
  def format_response(response)
    formatted_response = {
      status: response.status,
      transaction_id: response.id
    }
  end
  
  def format_error_response(error)
    formatted_resposne = {
      status: error.code,
      message: error.message
    }
  end
  
  def payment_request
   begin
     response = Stripe::Charge.create({
       amount: centify(amount_to_pay),
       currency: "usd",
       source: card,
       description: description
     })
     format_response(response)     
   rescue Stripe::CardError => e
     format_error_response(e)
   end
  end

  
  def centify(amount)
    amount_to_pay.respond_to?(:cents) ? amount_to_pay.cents : amount_to_pay
  end
  
end