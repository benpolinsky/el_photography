require 'rails_helper'
require 'pp'

RSpec.describe 'Variant Building' do
  
  before do
    @product = create(:product)
    @color_option = @product.options.create(name: "Color")
    @size_option = @product.options.create(name: "Size")
  end
  
  
  it "raises an argument error if no options are provided" do
    expect{@product.variants.create_from_properties_and_options}.to raise_error ArgumentError
  end


  it "can build a bunch (3x5) of variants from a product's options names and lists of values" do

    color_values = "Black, White, Green"
    size_values = "XS, S, M, L, XL"
    @product.variants.create_from_properties_and_options({
     @color_option => color_values,
     @size_option => size_values
    })
    expect(@product.variants.count).to eq 15
  end

   it "with empty values it merely returns nothing" do
     @product.variants.create_from_properties_and_options({
       @color_option => "",
       @size_option => ""
     })
     expect(@product.variants.count).to eq 0
   end

   it "with 1x1 value it returns one variant" do
     color_values = "Blue"
     @product.variants.create_from_properties_and_options({
       @color_option => color_values
     })
     expect(@product.variants.count).to eq 1
   end

   it "with 1000 (10x10x10) - LONG RUNNING BUT WORKS!!", speed: "slow", skip: true do
     monogram_option = @product.options.create(name: "Monogram")
     color_values = "Black, White, Green, Red, Blue, Aqua, Yellow, Orange, Violet, Charcoal"
     size_values = "WXS, WS, WM, WL, WXL, MXS, MS, MM, ML, MXL"
     monogram_values = "Ben, Carl, David, Elliot, Adam, Fred, George, Hayley, Issac, Jessica"

     @product.variants.create_from_properties_and_options({
       @color_option => color_values,
       @size_option => size_values,
       monogram_option => monogram_values
     })
     expect(@product.variants.count).to eq 1000
   end

   it "works with special characters" do
     color_values = "B@lack, ^(), )"
     size_values = "XS, S, M, :, X!"
     @product.variants.create_from_properties_and_options({
       @color_option => color_values,
       @size_option => size_values
     })
     expect(@product.variants.count).to eq 15
   end

   it "raises an error with a nil value" do
     color_values = nil
     expect{@product.variants.create_from_properties_and_options({
       @color_option => color_values
     })}.to raise_error NoMethodError
   end
  
   

   it "doesn't overwrite variants which already exist with the same name", focus: true do
     existing_variant = Variant.new(price: "999")
     existing_variant.option_values << OptionValue.new(option: @color_option, value: "Black")
     existing_variant.option_values << OptionValue.new(option: @size_option, value: "XS")
     @product.variants << existing_variant
     @product.save
     expect(@product.variants.include?(existing_variant)).to be true
     expect(@product.variants.count).to eq 1

     color_values = "Black"
     size_values = "XS"

     @product.variants.create_from_properties_and_options({
      @color_option => color_values,
      @size_option => size_values
     })
     
     expect(@product.variants.map(&:price_cents).include?(99900)).to be true
     expect(@product.variants.count).to eq 1
   end

   it "can deconstitute itself to a hash of options and value" do
     color_values = "Black, White, Green"
     size_values = "XS, S, M, L, XL"
     original_options = {
       @color_option => color_values,
       @size_option => size_values
     }
     @product.variants.create_from_properties_and_options(original_options)
     expect(@product.variants.count).to eq 15
     deconstituted_options = @product.variants.deconstitute
     expect(deconstituted_options).to eq original_options
     
   end
   
   
   it "can add variants to a product and it will merge with existing variants" do
     color_values = "Black, White, Green"
     size_values = "XS, S, M, L, XL"
     @product.variants.create_from_properties_and_options({
      @color_option => color_values,
      @size_option => size_values
     })
     expect(@product.variants.count).to eq 15
     batch_option = @product.options.create(name: "Batch")
     batch_values = "100, 500, 1000"
     @product.variants.add_from_properties_and_options({
       batch_option => batch_values
     })
     
      #@product.variants.create_from_properties_and_options()
     expect(@product.variants.count).to eq 45
   end
  
end
