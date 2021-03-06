class Address < ApplicationRecord
  STRIPE_COUNTRIES = ["US", "CA", "GB", "FR", "DE", "ES", "IT", "NL", "AU", "DK", "FI", "IE", "NO", "BE", "LU", "NL", "AT"]
  belongs_to :addressable, polymorphic: true
  
  validate :main_validation

  def main_validation
    [:first_name, :last_name, :street_line_1, :city, :state, :zip_code, :country].each do |required_att|
      errors.add(required_att, "#{required_att.to_s} is required") if self[required_att].blank?
    end
  end
  
  def name
    [first_name, last_name].join(" ")
  end
  
  def self.billing
    where(kind: "billing")
  end
  
  def self.shipping
    where(kind: "shipping")
  end
end
