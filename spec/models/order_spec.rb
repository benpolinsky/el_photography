require 'rails_helper'

RSpec.describe Order, :type => :model do
  
  context "order state" do
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
    
    it "transitions to awaiting_payment_confirmation after shipping_added" do
      order = create(:order_with_billing_address)
      order.create_shipping_address(attributes_for(:shipping_address))
      expect(order.add_addresses).to eq true
      expect{order.pending_confirmation!}.to change{order.status}.from('shipping_added').to('awaiting_payment_confirmation')
    end
    
    it "transitions to payment accepted from shipping added" do
      paypal_order = create(:paypal_order)
      expect{paypal_order.accept_payment}.to change{paypal_order.status}.from('shipping_added').to('payment_accepted')
    end

    it "transitions to payment failed from shipping added" do
      paypal_order = create(:paypal_order)
      expect{paypal_order.fail_payment!}.to change{paypal_order.status}.from('shipping_added').to('payment_failed')
    end

    it "transitions to payment failed from awaiting_payment_confirmation" do
      order = create(:order_with_billing_address)
      order.create_shipping_address(attributes_for(:shipping_address))
      order.add_addresses
      order.pending_confirmation!
      expect{order.accept_payment!}.to change{order.status}.from('awaiting_payment_confirmation').to('payment_accepted')
    end
    
    it "transitions to shipped from payment accepted if order ships" do
      order = create(:paid_paypal_order)
      order.accept_payment!
      expect{order.ship!}.to change{order.status}.from('payment_accepted').to('order_shipped')
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

    # TODO: This test is several tests....
    it "can update_totals! with new totals correctly from line items" do
      @order.update_totals!
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
      @order.update_totals!
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


    it "updates_totals with new params and new totals" do
      @order.update_with_totals({contact_email: 'new@new.com'})
      expect(@order.subtotal_cents).to eq 500+1100+500
      expect(@order.shipping_total_cents).to eq 250+50+1250
      expect(@order.grand_total_cents).to eq 500+250+1100+50+500+1250
      expect(@order.contact_email).to eq 'new@new.com'
      @order.update_with_totals({contact_email: 'newer@newer.com'})
      expect(@order.contact_email).to eq 'newer@newer.com'
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
