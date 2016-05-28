require 'rails_helper'

RSpec.describe Cart, :type => :model do
  context "states" do
    it "defaults to empty" do
      cart = Cart.new
      expect(cart.status).to eq 'empty'
    end
    
    it "can move through states" do
      cart = Cart.new
      cart.has_items!
      expect(cart.status).to eq "has_items"
      cart.in_line!
      expect(cart.status).to eq "in_line"
    end
  end
  
  context "totals" do
  end
  
  context "line items" do
    let(:cart_with_items) {create(:cart_with_five_items)}
    let(:cart) {create(:cart)}
    let(:product) {create(:published_product, price: 10, quantity: 3)}
    let(:product_two) {create(:published_product, price: 10, quantity: 3)}
    
    it "has many line items" do
      expect(cart_with_items.line_items.length).to eq 5
    end
    
    it "can add a product as an item", focus: true do
      expect(cart.line_items.length).to eq 0
      cart.add_cart_item(product.id, 'product')
      expect(cart.line_items.length).to eq 1
    end
    
    it "can add an already existing item" do
      expect(cart.line_items.length).to eq 0
      line_item = cart.add_cart_item(product.id, 'product')
      line_item.save
      expect(line_item.quantity).to eq 1
      line_item = cart.add_cart_item(product.id, 'product')
      line_item.save
      expect(cart.line_items.length).to eq 1
      cart.reload
      expect(cart.line_items.first.quantity).to eq 2
    end
    
    it "can empty its contents" do
      expect(cart_with_items.line_items.length).to eq 5
      cart_with_items.empty_contents
      expect(cart_with_items.line_items.length).to eq 0
    end
    
  
    it "returns the total number of items' quantity" do
      cart_with_items.line_items.map{|item| item.update(quantity: 1)}
      cart.save
      cart.reload
      expect(cart_with_items.number_of_items).to eq 5
    end
    
    it "determines if a line item corresponds to a given product" do
      line_item = cart.add_cart_item(product.id, 'product')
      line_item.save
      expect(cart.has_product(product)).to be true
      expect(cart.has_product(product_two)).to be false
    end
    
    it "can determine the number of a given product inside a cart" do
      line_item = cart.add_cart_item(product.id, 'product')
      line_item.save
      expect(cart.number_of_products_inside(product.id)).to eq 1
      expect(cart.number_of_products_inside(product_two.id)).to eq 0
    end
    
  end
end
