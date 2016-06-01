require 'rails_helper'

RSpec.describe LineItem, :type => :model do
  before do
    @line_item = build(:line_item)
  end
  
  context "basic" do
    it "exists" do
      expect(@line_item).to be_a LineItem
    end

    it "can return its name if it is associated with a product" do
      line_item = create(:line_item_with_product)
      line_item.product.update(name: "BLURGH")
      line_item.reload
      expect(line_item.product_or_variant_name).to eq "BLURGH"
    end
    
    it "can return its name if it is associated with a variant" do
      Variant.destroy_all
      line_item = build(:line_item_with_variant)
      
      line_item.save
      line_item.product_or_variant_name
      expect(line_item.product_or_variant_name).to eq line_item.variant.name_with_product
    end
  end
  
  context "totals" do
    it "calculates subtotals correctly" do
      line_item = build(:line_item, quantity: 1, price_cents: 300)
      expect(line_item.subtotal_cents).to eq 300
      
      line_item.update_attributes(quantity: 0, price_cents: 300)
      expect(line_item.subtotal_cents).to eq 0
      
      line_item.update_attributes(quantity: 1, price_cents: 0)
      expect(line_item.subtotal_cents).to eq 0
      
      line_item.update_attributes(quantity: 0, price_cents: 0)
      expect(line_item.subtotal_cents).to eq 0
      
      line_item.update_attributes(quantity: 5, price_cents: 1239109)
      expect(line_item.subtotal_cents).to eq 5 * 1239109
      
      line_item.update_attributes(quantity: 100, price_cents: 1239109)
      expect(line_item.subtotal_cents).to eq 100 * 1239109
      
      line_item.update_attributes(quantity: nil, price_cents: 1239109)
      expect(line_item.subtotal_cents).to eq 0
      
      line_item.update_attributes(quantity: 123, price_cents: nil)
      expect(line_item.subtotal_cents).to eq 0
    end
    
    it 'caluclates totals correctly' do
      line_item = build(:line_item, quantity: 1, price_cents: 300, shipping_base_cents: 100)
      expect(line_item.total_cents).to eq 400
      
      line_item.update_attributes(quantity: 2, price_cents: 300, shipping_base_cents: 100)
      expect(line_item.total_cents).to eq 800
      
      line_item.update_attributes(quantity: 2, price_cents: 300, shipping_base_cents: 0)
      expect(line_item.total_cents).to eq 600      
      
      line_item.update_attributes(quantity: 0, price_cents: 300, shipping_base_cents:10000)
      expect(line_item.total_cents).to eq 0
      
      line_item.update_attributes(quantity: 1, price_cents: 0, shipping_base_cents: 0)
      expect(line_item.total_cents).to eq 0
      
      line_item.update_attributes(quantity: 0, price_cents: 0, shipping_base_cents: 0)
      expect(line_item.total_cents).to eq 0
      
      line_item.update_attributes(quantity: 5, price_cents: 1239109, shipping_base_cents: 0)
      expect(line_item.total_cents).to eq 5 * 1239109
      
      line_item.update_attributes(quantity: 100, price_cents: 1239109, shipping_base_cents: 200)
      expect(line_item.total_cents).to eq (100 * 1239109) + (200*100)
      
      line_item.update_attributes(quantity: nil, price_cents: 1239109, shipping_base_cents: nil)
      expect(line_item.total_cents).to eq 0
      
      line_item.update_attributes(quantity: 123, price_cents: nil, shipping_base_cents: 0)
      expect(line_item.total_cents).to eq 0
    end
    
    it "can return its shipping total with additional shipping" do
      line_item = build(:line_item, quantity: 1, shipping_base_cents: 100, additional_shipping_per_item_cents: 50)
      expect(line_item.shipping_with_additional.cents).to eq 100
      line_item = build(:line_item, quantity: 2, shipping_base_cents: 100, additional_shipping_per_item_cents: 50)
      expect(line_item.shipping_with_additional.cents).to eq 150
      line_item = build(:line_item, quantity: 12, shipping_base_cents: 100, additional_shipping_per_item_cents: 50)
      expect(line_item.shipping_with_additional.cents).to eq 650
    end
    
    it "shipping total cents uses ShippingCalculator" do

      line_item = build(:line_item, quantity: 12, shipping_base_cents: 100, additional_shipping_per_item_cents: 50)
      expect(line_item.shipping_total_cents).to eq 650
    end
  end
  
  context "quantities" do
    it "can update its quantity" do
      @line_item.quantity = 10
      @line_item.decrement_quantity
      expect(@line_item.quantity).to eq 9
      
      @line_item.increment_quantity
      expect(@line_item.quantity).to eq 10
    end
    
    it 'deletes itself if its quantity goes to 0' do
      @line_item.quantity = 1
      @line_item.decrement_quantity
      expect(@line_item.destroyed?).to be true
    end
    
    it 'cannot increase quantity if decreased to 0, but try not to throw an error' do
      @line_item.quantity = 1
      @line_item.decrement_quantity
      @line_item.increment_quantity
      expect(@line_item.destroyed?).to be true
      expect(@line_item.quantity).to eq 0
    end
    
    pending "can tell if its able to increment" do
      line_item = create(:line_item_with_product)
      allow_any_instance_of(Product).to receive(:quantity_i_can_add_to_cart).and_return(3)
      line_item.quantity = 2
      expect(line_item.able_to_increment?(Cart.new)).to eq true
      allow_any_instance_of(Product).to receive(:quantity_i_can_add_to_cart).and_return(2)
      expect(line_item.able_to_increment?(Cart.new)).to eq false
    end
    
    it "can return its products available_quantity" do
      line_item = create(:line_item_with_product)
      line_item.product.update(quantity: 2)
      expect(line_item.available_quantity).to eq 2
    end
    
    it "can determine if its product or variant's quantity is only 1" do
      line_item = create(:line_item_with_product)
      line_item.product.update(quantity: 1)
      expect(line_item.product_solo?).to eq true
      line_item.product.update(quantity: 3)
      expect(line_item.product_solo?).to eq false
    end
    
    it "can return the subtotal for a given quantity" do
      line_item = create(:line_item_with_product, price: 2.00)
      line_item.product.update(quantity: 1)
      expect(line_item.subtotal_from(4).format).to eq "$8.00"
      line_item = create(:line_item_with_product, price: 3.10)
      line_item.product.update(quantity: 1)
      expect(line_item.subtotal_from(2).format).to eq "$6.20"
    end
  end
  
  context "product relationship" do
    it "can return its product" do
      line_item = build(:line_item_with_product)
      product = create(:product)
      line_item.store_product(product)
      expect(line_item.product).to eq product
    end
    
    it "can determine if its product is a product" do
      line_item = build(:line_item_with_product)
      expect(line_item.product?).to eq true
      expect(line_item.variant?).to eq false
    end
    
    it "can determine if its product is a variant" do
      line_item = build(:line_item_with_variant)
      expect(line_item.product?).to eq false
      expect(line_item.variant?).to eq true
    end
    
  end
  
  context "class methods" do
    it "can return a total of all of its line items" do
      LineItem.delete_all
      
      items = [
        create(:line_item_with_product, price_cents: 100, shipping_base_cents: 50, quantity:5),
        create(:line_item_with_product, price_cents: 1100, shipping_base_cents: 50, quantity:1),
        create(:line_item_with_product, price_cents: 11020, shipping_base_cents: 1250, quantity:1)
      ]
      expect(LineItem.calculate_total(items)).to eq 14170
      # shipping 1550 other = 12620
      
    end
  
  end
  
end
