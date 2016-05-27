FactoryGirl.define do
  factory :product do
    name "MyString"
    description "MyText"
    price_cents 1
    price_cents_currency "MyString"
    published_at "2016-05-26 20:51:49"
    quantity 1
    weight_in_oz 1
    row_order 1
    photo nil
    shipping_cents 1
    shipping_currency "MyString"
    slug "MyString"
    state 1
    deleted_at "2016-05-26 20:51:49"
    uid "MyString"
    international_shipping_cents 1
    international_shipping_currency "MyString"
  end
end
