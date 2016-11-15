FactoryGirl.define do
  factory :product do |p|
    p.sequence(:name) {|n| "#{Faker::Commerce.product_name})_#{n}"}
    p.price 100
    p.quantity 1

  end
  
  factory :published_product, parent: :product do |p|
    p.name { "#{Faker::Lorem.word})_#{Random.new.rand(0..111110000)}"}
    p.quantity 1
    p.price 150
    p.taken_down false
    p.description Faker::Lorem.paragraph
    p.published true
  end
end
