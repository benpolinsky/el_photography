class Order < ApplicationRecord
  include AASM
  attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_security_code
    
  aasm :column => :status, :whiny_transitions => false do
    state :empty
    state :email_added
    state :billing_added
    state :shipping_added
    state :payment_added
    state :payment_accepted
    state :payment_failed
    state :payment_confirmed
    state :order_shipped
    # state :order_received
    # state :return_requested
    
    event :add_email do
      transitions from: :empty, to: :email_added, :if => :contact_email
    end
    
    event :add_billing do
      transitions from: :email_added, to: :shipping_added, if: :shipping_same_as_billing, after: :copy_shipping_address
      transitions from: :email_added, to: :billing_added, if: :billing_address
    end
    
    event :add_shipping do
      transitions from: :billing_added, to: :shipping_added, if: :shipping_address
    end
    
    event :initialize_payment do
      transitions from: :shipping_added, to: :payment_added, if: :payment_credentials
    end
    
    event :accept_payment do
      transitions from: :payment_added, to: :payment_accepted, if: :payment_successful?
      transitions from: :payment_added, to: :payment_failed
    end
    
    event :confirm_payment do
      transitions from: :payment_accepted, to: :payment_confirmed, if: :payment_confirmed?
    end
    
    event :ship do
      transitions from: :payment_confirmed, to: :order_shipped
    end
    
  end
  
  has_many :line_items, as: :itemized, dependent: :delete_all
  has_many :addresses, as: :addressable 

  has_one :billing_address, -> {where(kind: 'billing')}, class_name: 'Address', as: :addressable, :dependent => :destroy
  has_one :shipping_address, -> {where(kind: 'shipping')}, class_name: 'Address', as: :addressable, :dependent => :destroy
  
  accepts_nested_attributes_for :addresses

  validates_associated :billing_address
  validates_associated :shipping_address, unless: :shipping_same_as_billing
  
  before_create :assign_uid
  after_create :assign_short_uid
  
  monetize :grand_total_cents, allow_nil: true
  
  
  def shipping_same_as_billing
    billing_address && shipping_same
  end
  
  
  def copy_shipping_address
    self.shipping_address = billing_address.dup
    self.shipping_address.kind = "shipping"
    save
  end
  
  def both_addresses_filled?
    billing_address && (shipping_address || shipping_same)
  end
  
  
  def payment_credentials
    case payment_method
    when "paypal"
      true 
    when "stripe"
      [credit_card_number, credit_card_exp_month, credit_card_exp_year, credit_card_security_code].all?(&:present?)
    else
      false
    end
  end
  
  def payment_successful?
    Payment.new(self).successful?
  end
  
  def payment_confirmed?
    Payment.new(self).confirmed?
  end
  
  def calculate_totals
    self.assign_attributes({
      subtotal_cents: items_subtotal_cents,
      shipping_total_cents: items_shipping_cents,
      grand_total_cents: items_subtotal_cents + items_shipping_cents
    })
  end
  
  def items_subtotal_cents
    self.line_items.to_a.sum(&:subtotal_cents)
  end

  def items_shipping_cents
    ShippingCalculator.new(self).total_shipping.cents
  end

  def items_total_cents
    self.line_items.to_a.sum(&:total_cents)
  end
  
  def assign_uid
    self.uid = SecureRandom.uuid
  end
  
  def assign_short_uid
    hashids = Hashids.new(self.created_at.to_i.to_s)
    self.update_attribute(:short_uid, hashids.encode(self.line_items.size, self.id, Order.all.size))
  end
  
  def short_or_uid
    short_uid ? short_uid : uid
  end
  
  
  def corresponding_products
    products = []
    self.line_items.each do |item|
      products << item.product_type.classify.constantize.find(item.product_id)
    end
    products
  end

  
  def self.find_product_from_item(item)
    item.product_type.classify.constantize.find(item.product_id)
  end  
end