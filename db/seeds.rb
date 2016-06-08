require 'faker'

5.times do |i|

  photo = Photo.create({
    remote_image_url: "https://placehold.it/300x400"
  })
  
  product = Product.create({
    name: "#{Faker::Commerce.product_name}_#{i}",
    price_cents: rand(100..1000),
    shipping_base_cents: rand(100..300),
    using_inventory: false,
    published_at: Time.zone.now - 2.days,
    photo: photo
  })
end

User.create({
  email: 'admin@admin.com',
  password: 'password'
})