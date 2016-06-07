require 'rails_helper'

# I should use VCR so I'm not hitting PayPay's servers
# unless there's a mock library already

RSpec.describe "PaypalPaymentProcessor" do
  it "must be initalized with an amount to pay" do
    expect{PaypalPaymentProcessor.new()}.to raise_error{ArgumentError}
    expect{PaypalPaymentProcessor.new(amount_to_pay: 1000)}.to_not raise_error{ArgumentError}
  end
  
  it "#process! returns a response containing a payment's status" do
    processor = PaypalPaymentProcessor.new(amount_to_pay: 1000)
    expect(processor.process![:status]).to eq "pending_confirmation"
  end
  
  it "#process! returns a response containing a payment's transaction_id" do
    processor = PaypalPaymentProcessor.new(amount_to_pay: 1000)
    expect(processor.process![:transaction_id]).to_not be_blank
  end

  it "tells if a payment was successful?" do
    processor = PaypalPaymentProcessor.new(amount_to_pay: 1000)
    expect(processor.payment_successful?).to eq false
  end

  it "tells if a payment is not successful" do
    processor = PaypalPaymentProcessor.new(amount_to_pay: 0)
    expect(processor.payment_successful?).to eq false
  end
  
  it "tells if a payment is pending" do
    processor = PaypalPaymentProcessor.new(amount_to_pay: 1000)
    expect(processor.payment_pending?).to eq true
  end
  
  skip "#complete! returns a successful payment response" do
    processor = PaypalPaymentProcessor.new(amount_to_pay: 1000)
    processor.process!
    raw_response = processor.raw_response

    token = raw_response.token
    response = processor.direct_confirmation(token)
    p response
    # processor.complete!()
  end

end