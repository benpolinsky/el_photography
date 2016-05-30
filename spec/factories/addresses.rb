FactoryGirl.define do  
  factory :full_address, class: Address do
    first_name "Joe"
    last_name "Person"
    street_line_1 "123 Fake St"
    street_line_2 "Apt 21 2nd Floor"
    country "U.S."
    city "Philadelphia"
    state "PA"
    zip_code "19119"
    phone_number "2152113111"
  end
  
  factory :billing_address, parent: :full_address do
    kind "billing"
  end
  
  factory :shipping_address, parent: :full_address do
    kind "shipping"
  end
end
