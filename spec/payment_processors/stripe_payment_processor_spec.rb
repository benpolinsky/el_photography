require 'rails_helper'
require 'support/payment_processors/mock_card'


# Until the stripe_mock gem gets its shit together w/r/t api versions,
# I should use VCR so I'm not hitting Stripe's test servers

RSpec.describe "StripePaymentProcessor" do
  it "must be initalized with a payment object and amount to pay" do
    expect{StripePaymentProcessor.new()}.to raise_error{ArgumentError}
    expect{StripePaymentProcessor.new(card: {token: 'sdsdsdsda'})}.to raise_error{ArgumentError}
    expect{StripePaymentProcessor.new(amount_to_pay: 100)}.to raise_error{ArgumentError}
    expect{StripePaymentProcessor.new(card: {token: 'sdasdsada'}, amount_to_pay: 1000)}.to_not raise_error{ArgumentError}
  end
  
  it "#process! returns a response containing a payment's status" do
    card = MockCard.new_valid
    processor = StripePaymentProcessor.new(card: card, amount_to_pay: 1000)
    expect(processor.process![:status]).to eq "succeeded"
  end
  
  it "#process! returns a response containing a payment's transaction_id" do
    card = MockCard.new_valid
    processor = StripePaymentProcessor.new(card: card, amount_to_pay: 1000)
    expect(processor.process![:transaction_id]).to be_present
  end
  

  it "tells if a payment was successful?" do
    card = MockCard.new_valid
    processor = StripePaymentProcessor.new(card: card, amount_to_pay: 1000)
    expect(processor.payment_successful?).to eq true
  end
  
  it "tells if a payment fails" do
    card = MockCard.new_failing
    processor = StripePaymentProcessor.new(card: card, amount_to_pay: 1000)
    expect(processor.payment_successful?).to eq false
  end

end