FactoryGirl.define do
  factory :cart_with_five_items, class: Cart do
    uid { Faker::Number.number(10) }    
    status 0
    after(:create) do |cart|       
      cart.line_items << build_list(:line_item_with_product, 5)
    end
  end
  
  factory :cart, class: Cart do
    uid { Faker::Number.number(10) }    
    status 0
  end
end
