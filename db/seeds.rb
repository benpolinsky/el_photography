Product.create({
  name: "A Product",
  price_cents: 100,
  shipping_base_cents: 10,
  using_inventory: false,
  published_at: Time.zone.now - 2.days
})

User.create({
  email: 'admin@admin.com',
  password: 'password'
})