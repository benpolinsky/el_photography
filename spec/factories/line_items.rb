FactoryGirl.define do
  factory :line_item do
    shipping_base_cents 300
    price {Faker::Commerce.price}
    quantity {rand(0..100).ceil}
  end
  
  factory :line_item_with_product, parent: :line_item do
    after(:build) do |line_item|
      product = create(:published_product)
      line_item.product_type = "product"
      line_item.product_id = product.id
    end
  end
  
  factory :line_item_with_variant, parent: :line_item do
    after(:build) do |line_item|
      variant = create(:variant)
      line_item.product_type = "variant"
      line_item.variant_id = variant.id
    end
  end
end
