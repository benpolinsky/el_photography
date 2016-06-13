require 'rails_helper'

RSpec.describe Option, :type => :model do
  context "products" do
    it "has many" do
      Product.delete_all
      option = Option.new(name: "Color")
      option.products << create(:product)
      option.products << create(:product)
      expect(option.products.size).to eq 2
    end
  end
  
  context "option values" do
    it "has many of them" do
      product = create(:product)
      option = Option.new(name: "Color", products: [product] )
      variant = Variant.create!(product: product, price: 1.11, shipping_base: 1)
      option.option_values.build(value: "Blue", variants: [variant])
      option.option_values.build(value: "Red", variants: [variant])
      option.option_values.build(value: "Green", variants: [variant])
      option.save!
      expect(option.option_values.count).to eq 3
    end
  end
  
  
  # context "deletion" do
#     it "on delete, it runs through each variant it is associated with and removes itself, and any corresponding values" do
#       product = create(:product)
#       product.options << Option.create(name: "Height")
#       option = product.options.first
#       variant = product.variants.build
#       variant.variant_option_values.build(name: "Tall", option: option)
#       product.variants << variant
#       expect(variant.options.count).to eq 1
#       expect(variant.variant_option_values.count).to eq 1
#       option.remove_from_variants_and_delete
#       expect(variant.options.count).to eq 0
#       expect(variant.variant_option_values.count).to eq 0
#     end
#
#     it "with multiple product variants" do
#       product = create(:product)
#       color_option = product.options.create(name: "Color")
#       size_option = product.options.create(name: "Size")
#       color_values = "Black, White, Green"
#       size_values = "XS, S, M, L, XL"
#       product.variants.create_from_properties_and_options({
#         color_option => color_values,
#         size_option => size_values
#       })
#       expect(product.variants.count).to eq 15
#       color_option.remove_from_variants_and_delete
#       product.variants.reload
#       expect(product.variants.count).to eq 5
#     end
#
#     it "works both ways" do
#       product = create(:product)
#       color_option = product.options.create(name: "Color")
#       size_option = product.options.create(name: "Size")
#       color_values = "Black, White, Green"
#       size_values = "XS, S, M, L, XL"
#       product.variants.create_from_properties_and_options({
#         color_option => color_values,
#         size_option => size_values
#       })
#       expect(product.variants.count).to eq 15
#       size_option.remove_from_variants_and_delete
#       product.variants.reload
#       expect(product.variants.count).to eq 3
#     end
#
#     # This spec should be run before deploys... and it might get changed...
#     skip "works with a 10x10", speed: "slow" do
#       product = create(:product)
#       color_option = product.options.create(name: "Color")
#       size_option = product.options.create(name: "Size")
#       monogram_option = product.options.create(name: "Monogram")
#       color_values = "Black, White, Green, Red, Blue, Aqua, Yellow, Orange, Violet, Charcoal"
#       size_values = "WXS, WS, WM, WL, WXL, MXS, MS, MM, ML, MXL"
#       monogram_values = "Ben, Carl, David, Elliot, Adam, Fred, George, Hayley, Issac, Jessica"
#
#       product.variants.create_from_properties_and_options({
#         color_option => color_values,
#         size_option => size_values,
#         monogram_option => monogram_values
#       })
#       expect(product.variants.count).to eq 1000
#       size_option.remove_from_variants_and_delete
#       product.variants.reload
#
#       expect(product.variants.count).to eq 100
#
#     end
#
#     it "handles deletion of all values / all variants are deleted", focus: true do
#       product = create(:product)
#       color_option = product.options.create(name: "Color")
#       size_option = product.options.create(name: "Size")
#       color_values = "Black, White, Green"
#       size_values = "XS, S, M, L, XL"
#       product.variants.create_from_properties_and_options({
#         color_option => color_values,
#         size_option => size_values
#       })
#       expect(product.variants.count).to eq 15
#       color_option.remove_from_variants_and_delete
#       expect(product.variants.count).to eq 5
#       size_option.remove_from_variants_and_delete
#       expect(product.variants.count).to eq 0
#     end
#
#     it "can return #unique_variant_values", focus: true do
#       product = create(:product)
#       color_option = product.options.create(name: "Color")
#       size_option = product.options.create(name: "Size")
#       color_values = "Black, White, Green"
#       size_values = "XS, S, M, L, XL"
#       product.variants.create_from_properties_and_options({
#         color_option => color_values,
#         size_option => size_values
#       })
#       expect(color_option.unique_variant_values.map(&:name)).to match_array color_values.split(", ")
#     end
#
#     it "can order itself by id" do
#       product = create(:product)
#       color_option = product.options.create(name: "Color")
#       size_option = product.options.create(name: "Size")
#       expect(Option.by_id).to eq [color_option, size_option]
#     end
#   end
end
