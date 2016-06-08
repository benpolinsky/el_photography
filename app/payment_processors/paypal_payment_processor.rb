# I need a common public interface for PaymentProcessors (rename to Gateways?)
# initialize sets up credentials - add ability to override
# process begins step 1
# complete if necessary step 2

class PaypalPaymentProcessor
  attr_reader :success_url, :cancel_url, :successful_payment_path, :options, :username,
              :password, :signature, :description, :amount_to_pay, :requires_confirmation,
              :response, :raw_response

  def initialize(args)
    @amount_to_pay = args[:amount_to_pay]
    @description = args[:description] || ""
    set_credentials
    set_options
  end

  def process!
    setup_request
  end
  
  def complete!(args)
    token = args[:token]
    payer_id = args[:payer_id]
    response = checkout(token, payer_id)
    format_response(response)
  end

  def payment_successful?
    process![:status] == "Success" #standardize these
  end
  
  
  def payment_pending?
    process![:status] == "pending_confirmation"
  end
  
  
  def direct_confirmation(token)
    request.details(token)
  end
  
  
  private
  
  # this is responisble for standardizing responses from the payment processor
  # we definitely need a status
  def format_response(response)
    @formatted_response = {
      status: paypal_response_status(response),
      transaction_id: response.correlation_id,
      second_step_url: response.redirect_uri
    }
  end
  
  def format_error_response(error)
    @formatted_response = {
      status: error.response.ack,
      message: error.response.details.map(&:long_message).join(", "),
      second_step_url: nil
    }
  end
  
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
  
  def setup_request
    begin
      response = request.setup(payment_request, success_url, cancel_url, options)
      @raw_response = response
      format_response(response)
    rescue Paypal::Exception::APIError => e
      format_error_response(e)
    end
  end
  
  def checkout(token, payer_id)
    request.checkout!(token, payer_id, payment_request)
  end
  
  def set_credentials
    @success_url = ENV['paypal_success_url']
    @cancel_url = ENV['paypal_cancel_url']
    @username = ENV['paypal_username']
    @password = ENV['paypal_password']
    @signature = ENV['paypal_signature']
  end
  
  def set_options
    @options = {
      no_shipping: false, 
      allow_note: false, 
      pay_on_paypal: true 
    }
    @requires_confirmation = true
  end

  def paypal_response_status(response)
    if response.ack == "Success" && response.payment_info.empty?
      "pending_confirmation"
    elsif response.ack == "Success" && response.payment_info[0].payment_status == "Completed"
      "Success"
    end
  end


end