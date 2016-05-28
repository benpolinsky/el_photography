require 'rails_helper'

RSpec.describe OptionValue, type: :model do
  before do
    Variant.destroy_all
    OptionValue.destroy_all
  end
  context "validations" do
    it "must have belong to one product option" do
      option_value = OptionValue.new(value: "blue", option: nil)
      option_value.variants << create_list(:variant, 5)
      option_value.valid?
      expect(option_value.errors[:option].count).to be 1
      product = create(:product)
      product_option = product.options.create(name: "Color")
      option_value.option = product_option
      option_value.save
      expect(option_value.errors[:option].count).to be 0
    end
  end
  
  
  context "product_option" do
    it "has one" do
      option_value = OptionValue.new(value: "blue")
      option_value.build_option(name: "Color")
      expect(option_value.option.class).to be Option
    end
  end
  
  context "variant" do
    it "has many" do
      option_value = OptionValue.new(value: "blue")
      option_value.variants << create_list(:variant, 5)
      expect(option_value.variants.first.class).to be Variant
    end
  end
  
  context "class methods" do 
    it "can return values with stock" do
      option_value = OptionValue.new(value: "blue", option: Option.new(name: "Color"))
      option_value.variants << create_list(:variant, 5, quantity: 2)
      option_value.save
      expect(OptionValue.with_stock).to eq [option_value]
    end
  end
end
