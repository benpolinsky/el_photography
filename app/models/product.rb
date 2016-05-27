class Product < ApplicationRecord
  belongs_to :photo
  monetize :price_cents
  monetize :shipping_cents
  monetize :international_shipping_cents
end
