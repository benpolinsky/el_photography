require 'rails_helper'

RSpec.describe Variant, :type => :model do
  before do
    product = create(:product)
    @variant = Variant.create(price_cents: 100000, product: product)
  end
  
  context "basic attributes" do
    before do
      @basic_attributes = [:price_cents, :row_order, :weight_in_oz, :quantity, :sku, :product_id]
    end
    
    it "contains all" do
      @basic_attributes.each do |att|
        expect(@variant).to respond_to att.to_s
      end
    end
    

  end
  
  context "validations" do
    it "must have a product" do
      @variant.product = nil
      expect(@variant.valid?).to be false
      expect(@variant.errors[:product].count).to be 1
      @variant.product = Product.create(name: "Garnet")
      expect(@variant).to be_valid
    end
  end
  
  context "products" do
    it "belongs to one" do
      expect(@variant.product.class).to be Product
    end
  end
  

  
  context "properties and values" do
    it "has many options through products" do
      expect(@variant.options.count).to be 0
      @variant.product.options.create(name: "Size")
      @variant.product.options.create(name: "Color")
      expect(@variant.options.count).to be 2
    end
    
    
    it "has many option values" do
      product_option = @variant.product.options.create(name: "Size")
      @variant.option_values.build(option: product_option, value: "L")
      @variant.option_values.build(option: product_option, value: "M")
      @variant.option_values.build(option: product_option, value: "S")
      @variant.save
      expect(@variant.option_values.count).to be 3
    end
  

    
    it "can find all variants with a specific variant_option_value name" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black, White, Green"
      size_values = "XS, S, M, L, XL"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(@product.variants.count).to eq 15
      xl_variants = @product.variants.with_value_name("Black")
      expect(xl_variants.count).to eq 5
    end
    
    it "can find variants by product option" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black, White, Green"
      size_values = "XS, S, M, L, XL"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(Variant.find_by_product_option(color_option.id)).to match_array @product.variants
    end

    it "can clean up variants with the same name" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      option_value = OptionValue.new(value: "Small", option: size_option)
      variant = @product.variants.new
      second_variant = @product.variants.new
      variant.option_values << option_value
      second_variant.option_values << option_value
      @product.save
      expect{@product.variants.clean_up}.to change{@product.variants.size}.from(2).to(1)
    end
    
    it "can clean up variants that dont belong to any product option anymore" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      option_value = OptionValue.new(value: "Small", option: size_option)
      variant = @product.variants.new
      second_variant = @product.variants.new
      variant.option_values << option_value
      second_variant.option_values << option_value
      @product.save
      @product.options.destroy_all
      expect{@product.variants.clean_up_strays(@product.options.size)}.to change{@product.variants.size}.from(2).to(0)
    end
    
    it "can return the its #name as a concatenation of option value names" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black"
      size_values = "XS"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(@product.variants.first.name).to eq "Black XS"
    end
    
    it "has a shortname, the first five characters of its name and elipsis" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black"
      size_values = "XS"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(@product.variants.first.short_name).to eq "Black..."
    end
    
    it "can return a name with a product" do
      @product = create(:product, name: "T Shirt")
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black"
      size_values = "XS"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(@product.variants.first.name_with_product).to eq "T Shirt Black XS"
    end
    
    it "can return a unique key based on its property values" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black, White, Green"
      size_values = "XS, S, M, L, XL"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(OptionValue.find(@product.variants.first.unique_key.split("_").first.to_i)).to be_in(OptionValue.all)
      expect(OptionValue.find(@product.variants.first.unique_key.split("_").last.to_i)).to be_in(OptionValue.all)
    end
    
  end
  
  context "convenience methods" do
    it "#only_one?" do
      product = create(:product)
      variant = product.variants.new(quantity: 1)
      expect{variant.quantity = 0}.to change{variant.only_one?}.from(true).to(false)
      expect{variant.quantity = 1}.to change{variant.only_one?}.from(false).to(true)
      expect{variant.quantity = nil}.to change{variant.only_one?}.from(true).to(false)
    end
    
    it "#has_stock?" do
      product = create(:product)
      variant = product.variants.new(quantity: 1)
      expect(variant.has_stock?).to eq true
      expect{variant.quantity = 0}.to change{variant.has_stock?}.from(true).to(false)
    end
    # PENDING CART 
    #
    # it "can list the #visible_stock" do
    #   product = create(:product)
    #   cart = instance_double("Cart", number_of_products_inside: 2)
    #   variant = product.variants.new(quantity: 3)
    #   expect(variant.visible_stock(cart)).to eq 1
    #   cart = instance_double("Cart", number_of_products_inside: 3)
    #   expect(variant.visible_stock(cart)).to eq 0
    # end
    #
   
    # AGAIN, Waitnig for cart
    # it "can list any variants that are ::stocked" do
#       Product.destroy_all
#       Variant.destroy_all
#       @product = Product.create(attributes_for(:product, quantity: 2))
#       color_option = @product.options.create(name: "Color")
#       size_option = @product.options.create(name: "Size")
#       color_values = "Black, White, Green"
#       size_values = "XS, S, M, L, XL"
#       options = {
#         color_option => color_values,
#         size_option => size_values
#       }
#       @product.variants.create_from_properties_and_options(options)
#       @variants = @product.variants
#       @variants.each {|v| v.update(quantity: 10)}
#       @variant = @variants.sort.first
#       @variant_two = @variants.sort.last
#       @variant.update(quantity: 5)
#       @variant_two.update(quantity: 1)
#       @cart = Cart.new
#       @cart_item = @cart.add_cart_item(@variant.id, 'variant', @buyer)
#       expect(Variant.stocked).to match_array @product.variants
#       @variant_two.update(quantity: 0)
#       expect(Variant.stocked).to_not include @variant_two
#     end
    
    it "#quantity_present?" do
      product = create(:product)
      variant = product.variants.new(quantity: 1)
      expect(variant.quantity_present?).to eq true
    end
  end
  
  context "class methods" do
    it "can deconstitute itself back into options and values" do
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black, White, Green"
      size_values = "XS, S, M, L, XL"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(@product.variants.deconstitute).to eq options
    end
    
    it "::with_quantity" do
      Variant.destroy_all
      @product = create(:product)
      color_option = @product.options.create(name: "Color")
      size_option = @product.options.create(name: "Size")
      color_values = "Black, White, Green"
      size_values = "XS, S, M, L, XL"
      options = {
        color_option => color_values,
        size_option => size_values
      }
      @product.variants.create_from_properties_and_options(options)
      expect(Variant.with_quantity.size).to eq 15
      expect{@product.variants.first.update(quantity: 0)}.to change{Variant.with_quantity.size}.by(-1)
    end
  end

end
