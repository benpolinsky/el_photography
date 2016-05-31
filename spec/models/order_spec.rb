require 'rails_helper'

RSpec.describe Order, :type => :model do
  
  context "order state flow" do
    let(:order) {build(:empty_order)}
    
    it "is empty when new" do
      expect(order.status).to eq 'empty'
      expect(order.persisted?).to eq false
    end
    
    it "transitions to contact_added after email_added if email present" do
      order.contact_email = "contact@me.com"
      expect{order.add_email}.to change{order.status}.from('empty').to('email_added')
    end
    
    it "doesn't transition to contact_added after email_added if email is not present" do
      expect(order.add_email).to eq false
    end
    
    it "transitions to billing_added after billing address is added" do
      address = build(:billing_address)
      order = create(:order_with_email)
      order.billing_address = address
      expect{order.add_billing}.to change{order.status}.from('email_added').to('billing_added')
    end
    
    it "doesn't transition to billing_added if an address isn't present" do
      order = create(:order_with_email)
      expect(order.add_billing).to eq false
    end
    
    it "transitions shipping_added if shipping is marked as same as billing" do
      address = create(:billing_address)
      order = create(:order_with_email)
      order.billing_address = address

      order.shipping_same = true
      order.save
      expect{order.add_billing}.to change{order.status}.from('email_added').to('shipping_added')
    end
    
    it "copies the billing address to shipping address if shipping same is marked as true", focus: true do
      address = create(:billing_address)
      order = create(:order_with_email)
      order.billing_address = address
      order.shipping_same = true
      order.add_billing
      expect(order.shipping_address.attributes.except("id", "created_at", "updated_at", "kind")).
      to eq order.billing_address.attributes.except!("id", "created_at", "updated_at", "kind")
    end
    
    it "doesn't transition to shipping_added if shipping is marked as same as billing but no billing address is present" do
      order = create(:order_with_email, shipping_same: true)
      expect(order.add_billing).to eq false
    end
    
    it "transitions to shipping filled after a shipping address is added" do
      order = create(:order_with_billing_address)
      order.create_shipping_address(attributes_for(:shipping_address))
      expect(order.add_shipping).to eq true
    end
    
    it "doesnt transition to shipping filled if no shipping address is added" do
      order = create(:order_with_billing_address)
      expect(order.add_shipping).to eq false
    end

    it 'transitions to payment_initiated if paypal is selected' do
      order = create(:order_with_addresses)
      order.payment_method = "paypal"
      expect{order.initialize_payment}.to change{order.status}.from("shipping_added").to("payment_added")
    end
    
    it "transitions to payment_initiated if stripe is selected and cc info entered" do
      order = create(:order_with_addresses)
      order.payment_method = "stripe"
      order.credit_card_number = 100
      order.credit_card_exp_month = 1
      order.credit_card_exp_year = 2020
      order.credit_card_security_code = 999
      expect{order.initialize_payment}.to change{order.status}.from("shipping_added").to("payment_added")
    end
    
    it "doesnt transition to payment_initiated if no payment method selected" do
      order = create(:order_with_addresses)
      expect(order.initialize_payment).to eq false
    end
    
    it "doesnt transition to payment_initiated if all stripe fields are not entered" do
      order = create(:order_with_addresses)
      order.payment_method = "stripe"
      order.credit_card_number = nil
      order.credit_card_exp_month = nil
      order.credit_card_exp_year = nil
      order.credit_card_security_code = nil
      expect(order.initialize_payment).to eq false
      order.credit_card_number = 9999999999999999
      expect(order.initialize_payment).to eq false
      order.credit_card_exp_month = 9
      expect(order.initialize_payment).to eq false
      order.credit_card_exp_year = 2019
      expect(order.initialize_payment).to eq false
      order.credit_card_security_code = 999
      expect(order.initialize_payment).to eq true
    end
    
    
    it "transitions to payment accepted after accepting a payment" do
      paypal_order = create(:paypal_order)
      Payment.any_instance.stub(:pay_via_paypal).and_return(true)
      expect{paypal_order.accept_payment}.to change{paypal_order.status}.from('payment_added').to('payment_accepted')
    end
  #
  #   it "transitions to payment failed after a failed payment" do
  #     order_with_addresses = create(:order_shipping_filled)
  #     expect(order_with_addresses.status).to eq "shipping_filled"
  #     payment_response = PaymentResponseMock.new(false)
  #     order_with_addresses.accept_payment!(payment_response.paid)
  #     expect(order_with_addresses.status).to eq "payment_failed"
  #   end
  #
  #   it "transitions to payment failed from payment accepted if payment succeeds" do
  #     failed_order = create(:failed_order)
  #     expect(failed_order.status).to eq "payment_failed"
  #     payment_response = PaymentResponseMock.new(true)
  #     failed_order.accept_payment!(payment_response.paid)
  #     expect(failed_order.status).to eq "payment_accepted"
  #   end
  #
  #   it "transitions to shipped from payment accepted if order ships" do
  #     paid_order = create(:paid_order)
  #     paid_order.ship!
  #     expect(paid_order.status).to eq "order_shipped"
  #   end
  #
  #   it "transitions to received if order recieved" do
  #     shipped_order = create(:shipped_order)
  #     shipped_order.received!
  #     expect(shipped_order.status).to eq "order_received"
  #   end
  #
  #
   end
  #
  # context "totals" do
  #   before do
  #     items = [
  #       create(:line_item_with_product, price_cents: 100, shipping_cents: 50, quantity:5),
  #       create(:line_item_with_product, price_cents: 1100, shipping_cents: 50, quantity:1),
  #       create(:line_item_with_product, price_cents: 500, shipping_cents: 1250, quantity:1)
  #     ]
  #     @order = Order.new
  #     @order.line_items << items
  #
  #     @order.save
  #   end
  #
  #   it "calculates totals correctly from line items" do
  #     @order.calculate_totals
  #     expect(@order.subtotal_cents).to eq 500+1100+500
  #     expect(@order.total_cents).to eq 500+250+1100+50+500+1250
  #
  #     items = [
  #       create(:line_item_with_product, price_cents: 0, shipping_cents: 50, quantity:5),
  #       create(:line_item_with_product, price_cents: 50, shipping_cents: 50, quantity:2),
  #       create(:line_item_with_product, price_cents: 500, shipping_cents: 1250, quantity:1)
  #     ]
  #
  #
  #     @order.line_items.delete_all
  #     @order.line_items << items
  #     @order.save
  #     @order.calculate_totals
  #     expect(@order.subtotal_cents).to eq 0+100+500
  #     expect(@order.total_cents).to eq 250+200+1750
  #
  #
  #     items = [
  #         create(:line_item_with_product, price_cents: 0, shipping_cents: 50, quantity:5),
  #         create(:line_item_with_product, price_cents: 50, shipping_cents: 50, quantity:2),
  #         create(:line_item_with_product, price_cents: 500, shipping_cents: 1250, quantity:1)
  #     ]
  #
  #
  #     @order.line_items.delete_all
  #     @order.line_items << items
  #     @order.save
  #     expect(@order.subtotal_cents).to eq 0+100+500
  #     expect(@order.total_cents).to eq 250+200+1750
  #   end
  #
  #   it "calculates the total with no discounts" do
  #     order = create(:order_shipping_filled)
  #     order.calculate_totals!
  #     expect(order.discount_type).to eq nil
  #     expect(order.discount).to eq Money.new(0)
  #     expect(order.subtotal).to eq Money.new(2100)
  #     expect(order.subtotal_with_discount).to eq Money.new(2100)
  #     expect(order.total_with_discount).to eq Money.new(2100+1550)
  #   end
  # end
  #
  # context "deletion" do
  #   before do
  #     items = [
  #       LineItem.create(price_cents: 100, shipping_cents: 50, quantity:5),
  #       LineItem.create(price_cents: 1100, shipping_cents: 50, quantity:1),
  #       LineItem.create(price_cents: 500, shipping_cents: 1250, quantity:1)
  #     ]
  #     @order = Order.new
  #     @order.line_items << items
  #
  #     @order.save
  #   end
  #
  #   it "cant be deleted" do
  #     expect(@order.deleted_at).to be nil
  #     @order.delete
  #     expect(@order.deleted_at).to_not be nil
  #   end
  # end
  #
  #
  #
  #
  # context "instance methods" do
  #   it "can find all products corresponding to its lineitems" do
  #     order = create(:shipped_order)
  #     products = []
  #     order.line_items.each do |item|
  #       products << Product.find(item.product_id)
  #     end
  #     expect(order.corresponding_products).to match products
  #   end
  # end
  #
  # context "class methods" do
  #   it "can find a line_item's corresponding product" do
  #     order = create(:shipped_order)
  #     line_item = order.line_items.last
  #     product = Order.find_product_from_item(line_item)
  #     product_type = line_item.product_type
  #     expect(product).to eq product_type.classify.constantize.find(order.line_items.last.product_id)
  #   end
  # end
  #
  # context "Order short-uid" do
  #   it "is a hashid of a users id, an orders id, and number of orders for user" do
  #     order = create(:paid_order)
  #     hashids = Hashids.new(order.seller.created_at.to_i.to_s)
  #     expect(order.short_uid).to eq hashids.encode(order.seller.id, order.id, order.seller.orders.count)
  #     expect(hashids.decode(order.short_uid)).to eq([order.seller.id, order.id, order.seller.orders.count])
  #   end
  #
  #   it "is unique to each order" do
  #     order = create(:paid_order)
  #     order_two = create(:paid_order)
  #     expect(order.short_uid).to_not eq order_two.short_uid
  #   end
  #
  # end
  
end
