option = Option.create!([
  {name: "Size"}
])
OptionValue.create!([
  {value: "S", option_id: option.id},
  {value: "M", option_id: option.id},
  {value: "L", option_id: option.id}
])

product = Product.create!([
  {name: "Ergonomic Iron Car_0", description: "", price_cents: 566, price_cents_currency: nil, published: true, quantity: nil, weight_in_oz: nil, row_order: 0, photo_id: 1, using_inventory: false, shipping_base_cents: 273, shipping_base_currency: "USD", additional_shipping_per_item_cents: nil, additional_shipping_per_item_currency: nil, international_shipping_base_cents: nil, international_shipping_base_currency: nil, additional_international_shipping_per_item_cents: nil, additional_international_shipping_per_item_currency: nil, slug: "ergonomic-iron-car_0", state: nil, deleted_at: nil, uid: nil, taken_down: nil, options: [option.id]}
])

Variant.create!([
  {price_cents: 1000, price_cents_currency: nil, sku: nil, quantity: 1, weight_in_oz: nil, row_order: 6291456, slug: nil, published: nil, state: nil, uid: nil, deleted_at: nil, product_id: product.id, using_inventory: false, shipping_base_cents: 200, shipping_base_currency: "USD", additional_shipping_per_item_cents: 100, additional_shipping_per_item_currency: "USD", international_shipping_base_cents: nil, international_shipping_base_currency: nil, additional_international_shipping_per_item_cents: nil, additional_international_shipping_per_item_currency: nil, option_values: [2]},
  {price_cents: 1100, price_cents_currency: nil, sku: nil, quantity: 1, weight_in_oz: nil, row_order: 4194304, slug: nil, published: nil, state: nil, uid: nil, deleted_at: nil, product_id: product.id, using_inventory: false, shipping_base_cents: 200, shipping_base_currency: "USD", additional_shipping_per_item_cents: 100, additional_shipping_per_item_currency: "USD", international_shipping_base_cents: nil, international_shipping_base_currency: nil, additional_international_shipping_per_item_cents: nil, additional_international_shipping_per_item_currency: nil, option_values: [3]}
])

Photo.create!([
  {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 0},
  {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 4194304},
  {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 6291456},
  {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 7340032},
  {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 7864320}
])

