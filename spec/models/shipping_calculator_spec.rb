require "rails_helper"

RSpec.describe ShippingCalculator do
  let(:order) {create(:order_with_addresses)}
  
  pending "can determine if it is #domestic?" do
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq true
    
    order.shop.address.update(country: "GB")
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq false
    
    order.shipping_address.update(country: "GB")
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq true
  end
  
  pending "can determine if it is #international?" do
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq false
    
    order.shop.address.update(country: "GB")
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    
    order.shipping_address.update(country: "GB")
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq false
  end
  
  pending "can determine if a domestic order's line item uses additional shipping" do
    order.line_items.each{|line_item| line_item.update(shipping_additional: 999)}
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq true
    expect(calc.additional?(order.line_items.first)).to eq true
    order.line_items.each{|line_item| line_item.update(shipping_additional: 0)}
    calc = ShippingCalculator.new(order)
    expect(calc.additional?(order.line_items.first)).to eq false
  end
  
  pending "can determine if an international order's line item uses additional shipping" do
    order.shop.address.update(country: "IT")
    order.line_items.each{|line_item| line_item.update(international_shipping_additional: 999)}
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    expect(calc.additional?(order.line_items.first)).to eq true
    order.line_items.each{|line_item| line_item.update(international_shipping_additional: 0)}
    calc = ShippingCalculator.new(order)
    expect(calc.additional?(order.line_items.first)).to eq false
  end
  
  pending "can calulate the total for a domestic order's item for a single item" do
    order.line_items.each{|line_item| line_item.update(shipping_cents: 999, quantity: 1)}
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq true
    expect(order.line_items.all?{|item| calc.additional?(item)}).to eq false
    expect(calc.shipping_cost(order.line_items.first).cents).to eq 999
  end
  
  pending "can calulate the total for a domestic order's item for multiple items" do
    order.line_items.each{|line_item| line_item.update(shipping_cents: 999, quantity: 5)}
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq true
    expect(order.line_items.all?{|item| calc.additional?(item)}).to eq false
    expect(calc.shipping_cost(order.line_items.first).cents).to eq 4995
  end
  
  pending "can calulate the total for a domestic order's item with additonal shipping for multiple items" do
    order.line_items.each{|line_item| line_item.update(shipping_cents: 999, shipping_additional_cents: 599, quantity: 5)}
    calc = ShippingCalculator.new(order)
    expect(calc.domestic?).to eq true
    expect(order.line_items.all?{|item| calc.additional?(item)}).to eq true
    expect(calc.additional_shipping_cost(order.line_items.first).cents).to eq 3395
  end
  
  pending "can calulate the total for a international order's item for a single item" do
    order.line_items.each{|line_item| line_item.update(shipping_cents: 999, international_shipping_cents: 1200, quantity: 1)}
    order.shop.address.update(country: "AU")
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    expect(order.line_items.all?{|item| calc.additional?(item)}).to eq false
    expect(calc.international_shipping_cost(order.line_items.first).cents).to eq 1200
  end
  
  pending "can calulate the total for a international order's item for multiple items" do
    order.line_items.each do |line_item| 
      line_item.update(
        shipping_cents: 999, 
        shipping_additional_cents: 222, 
        international_shipping_cents: 900,
        quantity: 5)
      end
    order.shop.address.update(country: "GB")
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    expect(order.line_items.all?{|item| calc.additional?(item)}).to eq false
    expect(calc.international_shipping_cost(order.line_items.first).cents).to eq 4500
  end
  
  pending "can calulate the total for a international order's item with additonal shipping for multiple items" do
    order.line_items.each do |line_item| 
      line_item.update(
        shipping_cents: 999, 
        shipping_additional_cents: 222, 
        international_shipping_cents: 900,
        international_shipping_additional_cents: 700, 
        quantity: 5)
      end
    order.shop.address.update(country: "GB")
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    expect(order.line_items.all?{|item| calc.additional?(item)}).to eq true
    expect(calc.international_additional_shipping_cost(order.line_items.first).cents).to eq 3700
  end
  
  pending "can determine the shipping cost for a domestic line item without additional" do
    order.line_items.each{|line_item| line_item.update(shipping_cents: 999, shipping_additional_cents: 0, quantity: 5)}
    calc = ShippingCalculator.new(order)
    expect(calc.determine_shipping_cost(order.line_items.last).cents).to eq 4995
  end
  
  pending "can determine the shipping cost for a domestic line item with additional" do
    order.line_items.each{|line_item| line_item.update(shipping_cents: 999, shipping_additional_cents: 599, quantity: 5)}
    calc = ShippingCalculator.new(order)
    expect(calc.determine_shipping_cost(order.line_items.last).cents).to eq 3395
  end

  pending "can determine the shipping cost for a international line item without additional" do
    order.shop.address.update(country: "GB")    
    order.line_items.each do |line_item| 
      line_item.update(
        shipping_cents: 999, 
        shipping_additional_cents: 222, 
        international_shipping_cents: 900,
        quantity: 5)
      end
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    expect(calc.determine_shipping_cost(order.line_items.last).cents).to eq 4500
  end
  
  pending "can determine the shipping cost for a international line item with additional" do
    order.shop.address.update(country: "GB")    
    order.line_items.each do |line_item| 
      line_item.update(
        shipping_cents: 999, 
        shipping_additional_cents: 222, 
        international_shipping_cents: 900,
        international_shipping_additional_cents: 499,
        quantity: 5)
      end
    calc = ShippingCalculator.new(order)
    expect(calc.international?).to eq true
    expect(calc.determine_shipping_cost(order.line_items.last).cents).to eq 2896
  end

  context "it can calculate the total shipping cost", focus: true do
    before do
      @order = order
      @order.line_items.each do |line_item| 
        line_item.update(
          shipping_cents: 999, 
          international_shipping_cents: 900,
          quantity: 5)
        end
      @calc = ShippingCalculator.new(@order)        
    end
    
    pending "for a domestic order with no additional" do
      expect(@calc.domestic?).to eq true
      expect(@order.line_items.size).to eq 3
      expect(@calc.total_shipping.cents).to eq 14985
      
      @order.line_items.first.update(shipping_cents: 493)
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 12455
      
    end
    
    pending "for a domestic order with all additional" do
      @order.line_items.each{|line_item| line_item.update(shipping_additional_cents: 509)}
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 9105
      @order.line_items.first.update(shipping_cents: 3412, shipping_additional_cents: 213, quantity: 2)
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 9695
    end
    
    pending "for a domestic order with mixed additional and non-additional" do
      @order.line_items.first.update(shipping_cents: 3412, shipping_additional_cents: 189, quantity: 6)
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 14347
    end
    
    pending "for a international order with no additional" do
      @order.shop.address.update(country: "BLURG")
      @calc.update(@order)
      
      expect(@calc.international?).to eq true
      expect(@order.line_items.size).to eq 3
      expect(@calc.total_shipping.cents).to eq 13500
      
      @order.line_items.first.update(international_shipping_cents: 493, quantity: 3)
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 10479
    end
    
    pending "for a international order with all additional" do
      @order.shop.address.update(country: "BLURG")
      @order.line_items.each{|line_item| line_item.update(international_shipping_additional_cents: 5612)}
      @calc.update(@order)
      
      expect(@calc.international?).to eq true
      expect(@order.line_items.size).to eq 3
      expect(@calc.total_shipping.cents).to eq 70044

      @order.line_items.first.update(international_shipping_cents: 493, international_shipping_additional_cents: 5777, quantity: 13)
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 116513
    end

    pending "for a international order with mixed additional and non-additional" do
      @order.shop.address.update(country: "BLURG")
      @order.line_items.first.update(international_shipping_cents: 493, international_shipping_additional_cents: 5777, quantity: 13)
      @calc.update(@order)
      expect(@calc.total_shipping.cents).to eq 78817
    end
  end
  
  context "calculating for a single line item" do
    # before do
 #      @order = order
 #      @order.line_items.each do |line_item|
 #        line_item.update(
 #          shipping_cents: 999,
 #          international_shipping_cents: 900,
 #          quantity: 5)
 #        end
 #    end
 #
 #    pending "can determine if a line items totals are domestic or foreign", focus: true do
 #      calc = ShippingCalculator.new(nil, "United States", "United States")
 #      expect(calc.domestic?).to eq true
 #      calc = ShippingCalculator.new(nil, "United States", "France")
 #      expect(calc.domestic?).to eq false
 #      expect(calc.international?).to eq true
 #
 #    end
 #
 #    pending "can calulate a line item's totals without an order (domestic)" do
 #      calc = ShippingCalculator.new(nil, "United States", "United States")
 #      expect(calc.determine_shipping_cost(@order.line_items.first).cents).to eq 4995
 #    end
 #
 #    pending "can calulate a line item's totals without an order (international)" do
 #      calc = ShippingCalculator.new(nil, "United States", "France")
 #      expect(calc.determine_shipping_cost(@order.line_items.first).cents).to eq 4500
 #    end
  end
    
end