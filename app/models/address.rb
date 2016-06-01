class Address < ApplicationRecord
  STRIPE_COUNTRIES = ["US", "CA", "GB", "FR", "DE", "ES", "IT", "NL", "AU", "DK", "FI", "IE", "NO", "BE", "LU", "NL", "AT"]
  belongs_to :addressable, polymorphic: true
  
  def self.billing_first
    [find(kind: 'billing'), find(kind: 'shipping')]
  end
end
