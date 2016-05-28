FactoryGirl.define do
  factory :variant do
    sku "MyString"
    quantity 1
    weight_in_oz 1
    row_order 1
    slug "MyString"
    published false
    state "MyString"
    uid "MyString"
    deleted_at "2016-05-27 16:47:01"
    price_cents 1000
    shipping_base_cents 100
    international_shipping_base_cents 300
    additional_shipping_per_item_cents 100
    additional_international_shipping_per_item_cents 200
    product
  end
end
