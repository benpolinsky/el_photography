## README / TODO
- reorder tags
- quick way to add or remove tag
- and quick way to add/change caption for each

- very basic dynamic css added
  - Perhaps lint or other safety check?
  - Clean up past stylesheets in public directory
  - namespace everything within a body tag, or at least add the theme to the body
  - test in production env
  - eventually extract theme into gem

- wysiwig - hopefully trix, medium also an option

### Qs

- How are you breaking down your navigation?

Distinct Shop: (with ability to link from photos, so ability to link a product to a photo):
- No tags in shop to start.
- List of photos with a few sizes and then each size would have to have a unique photo.
- So each photo must have a size
- PayPal to start then move to stripe

Product
- has_many product_options (Size, Color, Frametype)

    
Variant
- belongs_to product
- has_and_belongs_to_many :variant_option_values
- has_many product_options (THROUGH products, so no real relation here)
- additonal atts
  - price_cents
  - price_currency
  - sku
  - quantity
  - weight_in_oz
  - row_order
  - slug
  - published
  - state
  - shipping_base_cents
  - shipping_base_currency
  - additional_shipping_per_item_cents
  - additional_shipping_per_item_currency
  - uid
  - delteted_at
  - international_shipping_cents
  - international_shipping_currency
  - international_additional_shipping_per_item_cents
  - international_additional_shipping_per_item_currency

