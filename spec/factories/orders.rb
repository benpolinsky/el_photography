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

end
