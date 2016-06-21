description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
landscape = "https://placehold.it/2000x1600"
portrait = "https://placehold.it/1600x2000"
option = Option.create!([
  {name: "Size"}
]).first

OptionValue.create!([
  {value: "S", option_id: option.id},
  {value: "M", option_id: option.id},
  {value: "L", option_id: option.id}
])

Photo.create!([
  {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 0}
])

product = Product.create!([
  {name: "Ergonomic Iron Car_0", description: description, price_cents: 566, price_cents_currency: nil, published_at: "2016-06-06 19:33:00", quantity: nil, weight_in_oz: nil, row_order: 0, photo_id: Photo.all.first.id, using_inventory: false, shipping_base_cents: 273, shipping_base_currency: "USD", additional_shipping_per_item_cents: nil, additional_shipping_per_item_currency: nil, international_shipping_base_cents: nil, international_shipping_base_currency: nil, additional_international_shipping_per_item_cents: nil, additional_international_shipping_per_item_currency: nil, slug: "ergonomic-iron-car_0", state: nil, deleted_at: nil, uid: nil, taken_down: nil, options: [option]}
])

Variant.create!([
  {
    price_cents: 1000, 
    price_cents_currency: nil, 
    sku: nil, 
    quantity: 1, 
    weight_in_oz: nil, 
    row_order: 6291456, 
    slug: nil, 
    published: nil, 
    state: nil, 
    uid: nil, 
    deleted_at: nil, 
    product_id: product.first.id, 
    using_inventory: false, 
    shipping_base_cents: 200, 
    shipping_base_currency: "USD", 
    additional_shipping_per_item_cents: 100, 
    additional_shipping_per_item_currency: "USD", 
    international_shipping_base_cents: nil, 
    international_shipping_base_currency: nil, 
    additional_international_shipping_per_item_cents: nil, 
    additional_international_shipping_per_item_currency: nil, 
    option_values: [OptionValue.first]
  },
  {
    price_cents: 1100, 
    price_cents_currency: nil,
    sku: nil, 
    quantity: 1, 
    weight_in_oz: nil, 
    row_order: 4194304, 
    slug: nil, 
    published: nil, 
    state: nil, 
    uid: nil, 
    deleted_at: nil, 
    product_id: product.first.id, 
    using_inventory: false, 
    shipping_base_cents: 200, 
    shipping_base_currency: "USD", 
    additional_shipping_per_item_cents: 100,
    additional_shipping_per_item_currency: "USD", 
    international_shipping_base_cents: nil, 
    international_shipping_base_currency: nil, 
    additional_international_shipping_per_item_cents: nil, 
    additional_international_shipping_per_item_currency: nil, 
    option_values: [OptionValue.last]
  }
])

User.create({email: "admin@admin.com", password: 'password'})

4.times do |t|
  Photo.create({
    caption: "Number: #{t} / Hey I'ma photo caption and you can put links in me. <a href='https://google.com'>Lik dis.</a>",
    remote_image_url: t.odd? ? landscape : portrait,
    tag_list: (t.odd? ? ['a tag'] : ['a different_tag'])
  })
end

2.times do |t|
  Video.create({
    address: "https://vimeo.com/87110435",
    caption: "Placeholder vidya",
    tag_list: (t.odd? ? ['a tag'] : ['a different_tag'])
  })
end

Tag.all.each do |tag|
  tag.save
end

pages = {
  products: 'product_index',
  product: 'product',
  about: 'about',
  contact: 'contact',
  home: 'home',
  tags: 'tags'
}

pages.each do |key, value|
  PageTemplate.create({
    title: key.to_s.titleize, page: value
  })  
end
