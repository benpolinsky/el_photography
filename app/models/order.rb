class Order < ApplicationRecord
  include AASM;
  extend FriendlyId
  
  friendly_id :uid

  attr_accessor :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, 
  :credit_card_security_code, :skip_email_validation, :payment
    
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
    
    event :add_addresses do
      transitions from: :email_added, to: :shipping_added, if: :shipping_same, after: :copy_shipping_address
      transitions from: :email_added, to: :billing_added, if: :billing_address
      transitions from: :email_added, to: :shipping_added, if: :both_addresses_filled?
      transitions from: :billing_added, to: :shipping_added, if: :shipping_address
    end
    
    event :initialize_payment do
      transitions from: :shipping_added, to: :payment_added, if: :payment_credentials
    end
    
    event :accept_payment do
      transitions from: :payment_added, to: :payment_accepted, if: :payment_successful?, after: :update_purchased_at
      transitions from: :payment_added, to: :payment_failed
    end
    
    event :fail_payment do
      transitions from: :payment_accepted, to: :payment_failed, after: :update_purchased_at
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
  
  accepts_nested_attributes_for :addresses, reject_if: proc { |attributes| attributes.except(:addressable_id, :addressable_type, :kind, :id).all?(&:blank?) }

  validates_associated :billing_address
  validates_associated :shipping_address, unless: :shipping_same
  validates_presence_of :contact_email, unless: :skip_email_validation
  
  before_create :assign_uid
  after_create :assign_short_uid
  
  monetize :grand_total_cents, allow_nil: true
  monetize :shipping_total_cents, allow_nil: true  
  

  def copy_shipping_address
    self.shipping_address = billing_address.dup
    self.shipping_address.kind = "shipping"
    self.shipping_address.save
  end
  
  def both_addresses_filled?
    billing_address && (shipping_address || shipping_same)
  end
  
  
  def payment_credentials
    case payment_method
    when "paypal"
      true 
    when "stripe"
      payment.card.present?
    else
      false
    end
  end
  
  def payment_successful?
    payment.successful?
  end
  
  def payment_confirmed?
    payment.confirmed?
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

  def process_addresses(params)
    assign_attributes(params)
    save(validate: false)
    add_email!
    add_addresses!
    save
  end
  
  def process_payment(params, card=nil)
    self.calculate_totals
    self.update_attributes(params)
    self.payment = Payment.new(self, card)
    self.initialize_payment
    self.accept_payment!
  end
  
  def update_purchased_at

    if aasm.to_state == :payment_accepted
      update(purchased_at: Time.zone.now)
    else
      update(purchased_at: nil)
    end
  end
  
  def self.find_product_from_item(item)
    item.product_type.classify.constantize.find(item.product_id)
  end  
end
