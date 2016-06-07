class PaypalPaymentProcessor
  attr_reader :success_url, :cancel_url, :successful_payment_path, :options, :username,
              :password, :signature, :description, :amount_to_pay, :requires_confirmation

  def initialize(args)
    @amount_to_pay = args[:amount_to_pay]
    @description = args[:description]
    @success_url = ENV['paypal_success_url']
    @cancel_url = ENV['paypal_cancel_url']
    @username = ENV['paypal_username']
    @password = ENV['paypal_password']
    @signature = ENV['paypal_signature']
    @options = {
      no_shipping: false, 
      allow_note: false, 
      pay_on_paypal: true 
    }
    @requires_confirmation = true
  end

  def process!
    begin
      response = request.setup(payment_request, success_url, cancel_url, options)
      response.try(:redirect_uri)
    rescue Paypal::Exception::APIError => e
      false
      # TODO: log error if occured: e.message, e.response.details
    end    
  end
  
  def complete!(token, payer_id)
    payment_response[0].payment_status
  end
  
  private
  
  def request
    Paypal::Express::Request.new(
      username: username,
      password: password,
      signature: signature
    )
  end
  
  def payment_request
    Paypal::Payment::Request.new(
      description: description,
      amount: amount_to_pay.to_f
    )
  end
  
  def checkout(token, payer_id)
    request.checkout!(token, payer_id, payment_request)
  end
  
  def payment_response
    checkout(token, payer_id).payment_info
  end

end