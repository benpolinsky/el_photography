require 'rails_helper'

RSpec.describe Product, type: :model do
  # it_behaves_like "favoriteable"
  # it_behaves_like "Quantifiable"  
  context "basic attributes" do
    before do
      Product.delete_all
      @product = create(:product, name: "my awesome listing")
      @basic_attributes = [:name, :price_cents, :description, :published, 
                          :row_order, :weight_in_oz, :quantity]
    end
    
    it "contains all" do
      @basic_attributes.each do |att|
        expect(@product.attributes).to include(att.to_s)
      end
    end

   # PENDING: friendly_id integration 
    # it "can display its name or slug" do
 #      @product.name = ""
 #      expect(@product.name_or_slug).to eq "my-awesome-listing"
 #      @product.name = "listing 2 electric boogaloo"
 #      expect(@product.name_or_slug).to eq "listing 2 electric boogaloo"
 #    end
  end
  
  context "validations" do
    before do
      Product.delete_all
      @product = create(:product, name: "my awesome listing")
    end
    it "is required to have a name and min length" do
      @product.name = nil
      expect(@product.valid?).to be false
      expect(@product.errors[:name].count).to be 2
      @product.name = "R"
      expect(@product.valid?).to be false
      expect(@product.errors[:name].count).to be 1
      @product.name = "Red Garnet Crystal Samples_#{Random.new.rand(0..10000)}"
      expect(@product).to be_valid
    end
    
    it "cannot have the same name" do
      @product.name = "The Same Listing"
      @product.save
      expect(@product).to be_valid

      expect(Product.create(name: "The Same Listing").errors[:name].count).to eq 1
      expect(Product.create(name: "Not The Same Listing").errors[:name].count).to eq 0
    end
  end
  
  context "class methods" do

    before do
      Product.delete_all
      create_list(:product, 5)
      @products = Product.all  
    end
    
    it "::recently_created sorts by created_at date" do
      first_product = @products.recently_created.first
      second_product = @products.recently_created.second
      last_product = @products.recently_created.last
      expect(first_product.created_at).to be > second_product.created_at
      expect(first_product.created_at).to be > last_product.created_at  
    end
    
    it "::recently_updated sorts by updated date" do
      first_product = @products.recently_updated.first
      second_product = @products.recently_updated.second
      last_product = @products.recently_updated.last
      expect(first_product.updated_at).to be > second_product.updated_at
      expect(first_product.updated_at).to be > last_product.updated_at  
    end
    
  end
  
  context "variants" do
    before do
      Product.delete_all
      @product = create(:product, name: "my awesome listing")
    end
    
    it "can add a bunch of variants" do
      @product.variants << Variant.new(price_cents: 100000, shipping_base: 2.22)
      @product.variants << Variant.new(price_cents: 100000, shipping_base: 2.22)
      @product.save
      expect(@product.variants.count).to eq 2
    end
  end
  
  # Tags?
  # context "categories" do
#
#   end
# context "tags" do
#   before do
#     Product.delete_all
#     @product = create(:product, name: "my awesome listing")
#   end
#   it "can take some tags" do
#     @product.tag_list.add("BLUE, CLEAR", parse: true)
#     @product.save
#     expect(@product.tags.count).to be 2
#   end
# end
#

  context "options" do
    before do
      Product.delete_all
      @product = create(:product, name: "my awesome listing")
    end
    it "can have many options" do
      options = %w(color size text_on_shirt)
      options.each do |option|
        @product.options.build(name: option)
      end
      @product.save
      expect(@product.options.count).to be 3
    end
  end
  
  
  # once carts are up and running
  skip "inventory" do
    
    skip "if there's only one it can't be added to a cart twice" do
      cart = create(:cart)
      product = create(:published_product, quantity: 1)
      expect(product.only_one?).to be true
      expect(cart.number_of_items).to eq 0
      line_item = cart.add_cart_item(product.id, "product")
      expect(cart.number_of_items).to eq 1
      cart.save
      cart.add_cart_item(product.id, "product").save
      puts line_item.inspect
    end
  
    
    
    it "can list the #visible_stock" do
      product = create(:product, quantity: 3)
      cart = instance_double("Cart", number_of_products_inside: 2)
      expect(product.visible_stock(cart)).to eq 1
      cart = instance_double("Cart", number_of_products_inside: 3)
      expect(product.visible_stock(cart)).to eq 0
    end
    
   
    it "can list all that have any visible stock" do
      Product.destroy_all
      @seller = create(:stripe_seller)
      @buyer = create(:confirmed_buyer)
      @second_buyer = create(:confirmed_buyer)
      product = create(:product, quantity: 1)
      product_two = create(:product, quantity: 5)
      @seller.shop.products << [product, product_two]
      @cart = Cart.new
      @cart_item = @cart.add_cart_item(product.id, 'product', @buyer)
      expect(Product.with_visible_stock(@cart)).to_not include product
      @cart_item_two = @cart.add_cart_item(product_two.id, 'product', @buyer)
      expect(Product.with_visible_stock(@cart)).to include product_two
    end
  end
  
  # come on.. other?
  context "other" do
    before do
      Product.delete_all
      @product = create(:product, name: "my awesome listing")
    end

    it  "can take a listing down if it is published" do
      product = create(:published_product)
      expect{product.take_down!}.to change{product.taken_down}.from(false).to(true)
    end
  
    it "can't take a listing down if it isnt published" do
      @product.take_down!
      expect(@product.taken_down).to_not eq true
    end
  
    it "can't take a listing down if its already taken down" do
      product = create(:published_product)
      expect{product.take_down!}.to change{product.taken_down}.from(false).to(true)
      expect(product.take_down!).to eq false
    end
  

  
    it "can determine if a listing is not taken down" do
      product = create(:published_product)
      expect{product.take_down!}.to change{product.not_taken_down?}.from(true).to(false)
    end
  
  end
  
  context "class methods" do
    before do
      Product.delete_all
      @product = create(:product, name: "my awesome listing")
    end
    
    
    it "retrieves the products that aren't taken down" do
      Product.destroy_all
      products = create_list(:published_product, 10)
      expect(Product.taken_down.size).to eq 0
      products.first.take_down!
      expect(Product.taken_down.size).to eq 1
      products.last.take_down!
      expect(Product.taken_down.size).to eq 2
    end
    
    it "retrieves published products" do
      Product.destroy_all
      expect{create_list(:published_product, 14)}.to change{Product.published.size}.by(14)
      expect{Product.published.last.update(published: false)}.to change{Product.published.size}.by(-1)
    end
    


  
    
    it "retrieves products by status if allowed" do
      Product.destroy_all
      create_list(:published_product, 10)
      Product.last.update_attributes(published: false)
      Product.first.update_attributes(published: false)
      expect(Product.status('published').size).to eq 8
      Product.published.last.take_down!
      Product.published.first.take_down!
      expect(Product.status('taken_down').size).to eq 2
      expect(Product.status('all').size).to eq 10
      expect(Product.status('published').size).to eq 6
    end
    
    it "retrieves products by date" do
      Product.destroy_all
      early_product = create(:published_product)
      expect(Product.by_date.first).to eq early_product
      Timecop.freeze(Time.zone.now + 2.days) do
        middle_product = create(:published_product)
        expect(Product.by_date.first).to eq middle_product
      end
    end
    
    it "sorts by the cheapest" do
      cheap = create(:published_product, price_cents: 1000)
      middle = create(:published_product, price_cents: 5000)
      expensive = create(:published_product, price_cents: 15000)
      expect(Product.cheapest.first).to eq cheap
      expect(Product.cheapest.last).to eq expensive
    end
    
    it "sorts by the most expensive" do
      cheap = create(:published_product, price_cents: 1000)
      middle = create(:published_product, price_cents: 5000)
      expensive = create(:published_product, price_cents: 15000)
      expect(Product.most_expensive.first).to eq expensive
      expect(Product.most_expensive.last).to eq cheap
    end
    
    it "orders products from a string parameter" do
      expect(Product).to receive(:by_relevance)
      Product.order_by("relevance")
      expect(Product).to receive(:by_date)
      Product.order_by("newest")
      expect(Product).to receive(:cheapest)
      Product.order_by("lowest_price")
      expect(Product).to receive(:most_expensive)
      Product.order_by("highest_price")
      expect(Product).to receive(:where).with(nil).and_return(Product.all)
      Product.order_by("shnitzle")
    end
    
    it "retrieves published products since a given time" do
      Product.destroy_all
      early = create(:published_product)
      expect(Product.new_since(Time.zone.now - 1.week)).to include early
      Timecop.freeze(Time.zone.now + 2.weeks) do
        middle = create(:published_product)
        expect(Product.new_since(Time.zone.now - 1.week)).to_not include early
        expect(Product.new_since(Time.zone.now - 1.week)).to include middle
      end
    end

    
    it "can group products by week" do
      Product.destroy_all
      create_list(:published_product, 10)
      first_product = Product.first
      Timecop.freeze(Time.zone.now + 2.weeks) do
        later_products = create_list(:published_product, 10)  
        expect(Product.all.by_week.keys.first).to eq first_product.created_at.beginning_of_week
      end
    end
    
  end
end
