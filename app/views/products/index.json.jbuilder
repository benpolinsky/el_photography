json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :price_cents, :price_cents_currency, :published_at, :quantity, :weight_in_oz, :row_order, :photo_id, :shipping_cents, :shipping_currency, :slug, :state, :deleted_at, :uid, :international_shipping_cents, :international_shipping_currency
  json.url product_url(product, format: :json)
end
