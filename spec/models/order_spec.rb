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
    
    it "doesn't transition to contact_added after email_added if email is not present", focus: true do
      expect(order.add_email).to eq false
      expect(order).to_not be_valid
      expect(order.errors[:contact_email].size).to eq 1
    end
    
    it "transitions to billing_added after billing address is added" do
      address = build(:billing_address)
      order = create(:order_with_email)
      order.billing_address = address
      expect{order.add_addresses}.to change{order.status}.from('email_added').to('billing_added')
    end
    
    it "doesn't transition to billing_added if an address isn't present" do
      order = create(:order_with_email)
      expect(order.add_addresses).to eq false
    end
    
    it "transitions shipping_added if shipping is marked as same as billing" do
      address = create(:billing_address)
      order = create(:order_with_email)
      order.billing_address = address

      order.shipping_same = true
      order.save
      expect{order.add_addresses}.to change{order.status}.from('email_added').to('shipping_added')
    end
    
    it "copies the billing address to shipping address if shipping same is marked as true" do
      address = create(:billing_address)
      order = create(:order_with_email)
      order.billing_address = address
      order.shipping_same = true
      order.add_addresses
      expect(order.shipping_address.attributes.except("id", "created_at", "updated_at", "kind")).
      to eq order.billing_address.attributes.except!("id", "created_at", "updated_at", "kind")
    end
    
    it "doesn't transition to shipping_added if shipping is marked as same as billing but no billing address is present" do
      order = create(:order_with_email, shipping_same: true)
      expect(order.add_addresses).to eq false
    end
    
    it "transitions to shipping filled after a shipping address is added" do
      order = create(:order_with_billing_address)
      order.create_shipping_address(attributes_for(:shipping_address))
      expect(order.add_addresses).to eq true
    end
    
    it "doesnt transition to shipping filled if no shipping address is added" do
      order = create(:order_with_billing_address)
      expect(order.add_addresses).to eq false
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
    
    
    it "transitions to payment accepted if a paypal payment is successful" do
      paypal_order = create(:paypal_order)
      expect_any_instance_of(Payment).to receive(:pay_via_paypal).and_return(true)
      expect{paypal_order.accept_payment}.to change{paypal_order.status}.from('payment_added').to('payment_accepted')
    end
    
    it "transitions to payment accepted if a stripe payment is successful" do
      order = create(:stripe_order)
      order.credit_card_number = 100
      order.credit_card_exp_month = 1
      order.credit_card_exp_year = 2020
      order.credit_card_security_code = 999
      order.initialize_payment
      expect_any_instance_of(Payment).to receive(:pay_via_stripe).and_return(true)
      expect{order.accept_payment}.to change{order.status}.from('payment_added').to('payment_accepted')
    end

    it "transitions to payment failed after a failed paypal payment" do
      paypal_order = create(:paypal_order)
      expect_any_instance_of(Payment).to receive(:pay_via_paypal).and_return(false)
      expect{paypal_order.accept_payment}.to change{paypal_order.status}.from('payment_added').to('payment_failed')
    end

    it "transitions to payment failed after a failed stripe payment" do
      order = create(:stripe_order)
      order.credit_card_number = 100
      order.credit_card_exp_month = 1
      order.credit_card_exp_year = 2020
      order.credit_card_security_code = 999
      order.initialize_payment
      expect_any_instance_of(Payment).to receive(:pay_via_stripe).and_return(false)
      expect{order.accept_payment}.to change{order.status}.from('payment_added').to('payment_failed')
    end
    
    it "transitions to payment confirmed from payment accepted when recieving confirmation from a paypal ipn" do
      order = create(:paid_paypal_order)
      expect_any_instance_of(Payment).to receive(:pay_via_paypal).and_return(true)
      order.accept_payment
      expect_any_instance_of(Payment).to receive(:receive_paypal_ipn).and_return(true)
      expect{order.confirm_payment}.to change{order.status}.from("payment_accepted").to("payment_confirmed")
    end

    it "confirmed from payment accepted when recieving confirmation from a stripe webhook" do
      order = create(:stripe_order)
      order.credit_card_number = 100
      order.credit_card_exp_month = 1
      order.credit_card_exp_year = 2020
      order.credit_card_security_code = 999
      order.initialize_payment
      expect_any_instance_of(Payment).to receive(:pay_via_stripe).and_return(true)
      expect{order.accept_payment}.to change{order.status}.from('payment_added').to('payment_accepted')
      expect_any_instance_of(Payment).to receive(:receive_stripe_webhook).and_return(true)
      expect{order.confirm_payment}.to change{order.status}.from("payment_accepted").to("payment_confirmed")
    end

    it "isn't confirmed if a failed paypal ipn response is received" do
      order = create(:paid_paypal_order)
      expect_any_instance_of(Payment).to receive(:pay_via_paypal).and_return(true)
      order.accept_payment
      expect_any_instance_of(Payment).to receive(:receive_paypal_ipn).and_return(false)
      expect(order.confirm_payment).to eq false
    end
    
    it "isn't confirmed if a failed stripe webhook is received" do
      order = create(:stripe_order)
      order.credit_card_number = 100
      order.credit_card_exp_month = 1
      order.credit_card_exp_year = 2020
      order.credit_card_security_code = 999
      order.initialize_payment
      expect_any_instance_of(Payment).to receive(:pay_via_stripe).and_return(true)
      expect{order.accept_payment}.to change{order.status}.from('payment_added').to('payment_accepted')
      expect_any_instance_of(Payment).to receive(:receive_stripe_webhook).and_return(false)
      expect(order.confirm_payment).to eq false
    end

    it "transitions to shipped from payment confirmed if order ships" do
      order = create(:paid_paypal_order)
      expect_any_instance_of(Payment).to receive(:pay_via_paypal).and_return(true)
      order.accept_payment
      expect_any_instance_of(Payment).to receive(:receive_paypal_ipn).and_return(true)
      order.confirm_payment
      expect{order.ship}.to change{order.status}.from('payment_confirmed').to('order_shipped')
    end

   end
 
  context "totals" do
    before do
      items = [
        create(:line_item_with_product, price_cents: 100, shipping_base_cents: 50, quantity:5),
        create(:line_item_with_product, price_cents: 1100, shipping_base_cents: 50, quantity:1),
        create(:line_item_with_product, price_cents: 500, shipping_base_cents: 1250, quantity:1)
      ]
      @order = Order.new
      @order.line_items << items

      @order.save
    end

    it "calculates totals correctly from line items" do
      @order.calculate_totals
      expect(@order.subtotal_cents).to eq 500+1100+500
      expect(@order.shipping_total_cents).to eq 250+50+1250
      expect(@order.grand_total_cents).to eq 500+250+1100+50+500+1250

      items = [
        create(:line_item_with_product, price_cents: 0, shipping_base_cents: 50, quantity:5),
        create(:line_item_with_product, price_cents: 50, shipping_base_cents: 50, quantity:2),
        create(:line_item_with_product, price_cents: 500, shipping_base_cents: 1250, quantity:1)
      ]


      @order.line_items.delete_all
      @order.line_items << items
      @order.save
      @order.calculate_totals
      expect(@order.subtotal_cents).to eq 0+100+500
      expect(@order.grand_total_cents).to eq 250+200+1750


      items = [
          create(:line_item_with_product, price_cents: 0, shipping_base_cents: 50, quantity:5),
          create(:line_item_with_product, price_cents: 50, shipping_base_cents: 50, quantity:2),
          create(:line_item_with_product, price_cents: 500, shipping_base_cents: 1250, quantity:1)
      ]


      @order.line_items.delete_all
      @order.line_items << items
      @order.save
      expect(@order.subtotal_cents).to eq 0+100+500
      expect(@order.grand_total_cents).to eq 250+200+1750
    end

    # discounts not implemented yet
    pending "calculates the total with no discounts" do
      order = create(:order_shipping_filled)
      order.calculate_totals!
      expect(order.discount_type).to eq nil
      expect(order.discount).to eq Money.new(0)
      expect(order.subtotal).to eq Money.new(2100)
      expect(order.subtotal_with_discount).to eq Money.new(2100)
      expect(order.total_with_discount).to eq Money.new(2100+1550)
    end
  end
  
  # pending dependency mess vis-a-vis paranoia 2 + rails 5, which for some reason I cannot get to resolve
  pending "deletion" do
    before do
      items = [
        LineItem.create(price_cents: 100, shipping_base_cents: 50, quantity:5),
        LineItem.create(price_cents: 1100, shipping_base_cents: 50, quantity:1),
        LineItem.create(price_cents: 500, shipping_base_cents: 1250, quantity:1)
      ]
      @order = Order.new
      @order.line_items << items

      @order.save
    end

    it "cant be deleted" do
      expect(@order.deleted_at).to be nil
      @order.delete
      expect(@order.deleted_at).to_not be nil
    end
  end



 
  context "instance methods" do
    it "can find all products corresponding to its lineitems" do
      order = create(:shipped_order)
      products = []
      order.line_items.each do |item|
        products << Product.find(item.product_id)
      end
      expect(order.corresponding_products).to match products
    end
  end

  context "class methods" do
    it "can find a line_item's corresponding product" do
      order = create(:shipped_order, line_items: [create(:line_item_with_product)])
      line_item = order.line_items.last
      product = Order.friendly.find_product_from_item(line_item)
      product_type = line_item.product_type
      expect(product).to eq product_type.classify.constantize.find(order.line_items.last.product_id)
    end
  end

  context "Order short-uid" do
    it "is a hashid of a users id, an orders id, and number of orders for user" do
      order = create(:paid_paypal_order)
      hashids = Hashids.new(order.created_at.to_i.to_s)
      expect(order.short_uid).to eq hashids.encode(order.line_items.size, order.id, Order.all.size)
      expect(hashids.decode(order.short_uid)).to eq([order.line_items.size, order.id, Order.all.size])
    end

    it "is unique to each order" do
      order = create(:paid_paypal_order)
      order_two = create(:paid_paypal_order)
      expect(order.short_uid).to_not eq order_two.short_uid
    end

  end
  
end
