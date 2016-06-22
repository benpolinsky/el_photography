# description = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
# landscape = "https://placehold.it/2000x1600"
# portrait = "https://placehold.it/1600x2000"
# option = Option.create!([
#   {name: "Size"}
# ]).first
#
# OptionValue.create!([
#   {value: "S", option_id: option.id},
#   {value: "M", option_id: option.id},
#   {value: "L", option_id: option.id}
# ])
#
# Photo.create!([
#   {caption: nil, remote_image_url: "https://placehold.it/500x500", slug: nil, deleted_at: nil, row_order: 0}
# ])
#
# product = Product.create!([
#   {name: "Ergonomic Iron Car_0", description: description, price_cents: 566, price_cents_currency: nil, published_at: "2016-06-06 19:33:00", quantity: nil, weight_in_oz: nil, row_order: 0, photo_id: Photo.all.first.id, using_inventory: false, shipping_base_cents: 273, shipping_base_currency: "USD", additional_shipping_per_item_cents: nil, additional_shipping_per_item_currency: nil, international_shipping_base_cents: nil, international_shipping_base_currency: nil, additional_international_shipping_per_item_cents: nil, additional_international_shipping_per_item_currency: nil, slug: "ergonomic-iron-car_0", state: nil, deleted_at: nil, uid: nil, taken_down: nil, options: [option]}
# ])
#
# Variant.create!([
#   {
#     price_cents: 1000,
#     price_cents_currency: nil,
#     sku: nil,
#     quantity: 1,
#     weight_in_oz: nil,
#     row_order: 6291456,
#     slug: nil,
#     published: nil,
#     state: nil,
#     uid: nil,
#     deleted_at: nil,
#     product_id: product.first.id,
#     using_inventory: false,
#     shipping_base_cents: 200,
#     shipping_base_currency: "USD",
#     additional_shipping_per_item_cents: 100,
#     additional_shipping_per_item_currency: "USD",
#     international_shipping_base_cents: nil,
#     international_shipping_base_currency: nil,
#     additional_international_shipping_per_item_cents: nil,
#     additional_international_shipping_per_item_currency: nil,
#     option_values: [OptionValue.first]
#   },
#   {
#     price_cents: 1100,
#     price_cents_currency: nil,
#     sku: nil,
#     quantity: 1,
#     weight_in_oz: nil,
#     row_order: 4194304,
#     slug: nil,
#     published: nil,
#     state: nil,
#     uid: nil,
#     deleted_at: nil,
#     product_id: product.first.id,
#     using_inventory: false,
#     shipping_base_cents: 200,
#     shipping_base_currency: "USD",
#     additional_shipping_per_item_cents: 100,
#     additional_shipping_per_item_currency: "USD",
#     international_shipping_base_cents: nil,
#     international_shipping_base_currency: nil,
#     additional_international_shipping_per_item_cents: nil,
#     additional_international_shipping_per_item_currency: nil,
#     option_values: [OptionValue.last]
#   }
# ])
#
# User.create({email: "admin@admin.com", password: 'password'})
#
# 4.times do |t|
#   Photo.create({
#     caption: "Number: #{t} / Hey I'ma photo caption and you can put links in me. <a href='https://google.com'>Lik dis.</a>",
#     remote_image_url: t.odd? ? landscape : portrait,
#     tag_list: (t.odd? ? ['a tag'] : ['a different_tag'])
#   })
# end
#
# 2.times do |t|
#   Video.create({
#     address: "https://vimeo.com/87110435",
#     caption: "Placeholder vidya",
#     tag_list: (t.odd? ? ['a tag'] : ['a different_tag'])
#   })
# end
#
# Tag.all.each do |tag|
#   tag.save
# end
#
# # production setup content
# # pages, templates, custom_fields
#
# pages = {
#   products: 'product_index',
#   about: 'about',
#   contact: 'contact',
#   home: 'home',
#   tags: 'tags',
#   header: "header",
#   footer: "footer"
# }
#
# pages.each do |key, value|
#   PageTemplate.create({
#     title: key.to_s.titleize, page: value
#   })
# end
#
# BpCustomFields::AbstractResource.create(name: "about")
# BpCustomFields::AbstractResource.create(name: "contact")
#
#\

BpCustomFields::GroupTemplate.create!([
  {
    name: "About", visible: nil, appearances: [ BpCustomFields::Appearance.create({resource: "BpCustomFields::AbstractResource", resource_id: "about", appears: true, row_order: nil, group_template_id: 1})]
  },
  {
    name: "Contact", visible: nil, appearances: [ BpCustomFields::Appearance.create(  {resource: "BpCustomFields::AbstractResource", resource_id: "contact", appears: true, row_order: nil, group_template_id: 2})]
  }
])

BpCustomFields::FieldTemplate.create!([
  {name: "Contact Page Title", label: "Contact Page Title", group_template_id: 2, field_type: "string", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 1},
  {name: "Contact Page Text", label: "Contact Page Text", group_template_id: 2, field_type: "text", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 2},
  {name: "About Page Title", label: "About Page Title", group_template_id: 1, field_type: "string", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 3},
  {name: "About Page Text", label: "About Page Text", group_template_id: 1, field_type: "text", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 4},
  {name: "About Image", label: "About Image", group_template_id: 1, field_type: "image", min: "", max: "", required: false, instructions: "", default_value: "", placeholder_text: nil, prepend: "", append: "", rows: nil, date_format: "", time_format: "", accepted_file_types: "", toolbar: "Full", choices: "", multiple: false, parent_id: nil, row_order: 5}
])

BpCustomFields::AbstractResource.create!([
  {name: "about"},
  {name: "contact"}
])


