FactoryGirl.define do
  factory :empty_order, class: Order do
    uid { Faker::Number.number(10) }
    grand_total_cents "999"
  end
  
  factory :order_with_email, parent: :empty_order do
    contact_email "ilovephotos@yup.com"
    after(:create) do |order|
      order.add_email
    end
  end
  
  factory :order_with_billing_address, parent: :order_with_email do
    association :billing_address, factory: :billing_address
    after(:create) do |order|
      order.add_billing
    end
  end
  
  factory :order_with_addresses, parent: :order_with_billing_address do
    association :shipping_address, factory: :shipping_address
    after(:create) do |order|
      order.add_shipping
    end
  end
  
  factory :paypal_order, parent: :order_with_addresses do
    payment_method "paypal"
    after(:create) do |order|
      order.initialize_payment
    end
  end
  


end
