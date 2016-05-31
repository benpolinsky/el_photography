class Order < ApplicationRecord
  include AASM
  attr_accessor :shipping_same, :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_security_code
    
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
    state :order_received
    state :return_requested
    
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
      transitions from: :payment_accepted, to: :payment_confirmed
    end
    
  end
  
  has_many :line_items, as: :itemized, dependent: :delete_all
  has_many :addresses, as: :addressable do
    def find_or_build_by(attributes = nil, &block)
      find_by(attributes) || build(attributes, &block)
    end
  end

  has_one :billing_address, -> {where(kind: 'billing')}, class_name: 'Address', as: :addressable, :dependent => :destroy
  has_one :shipping_address, -> {where(kind: 'shipping')}, class_name: 'Address', as: :addressable, :dependent => :destroy
    
  # this belongs in checkout
  def self.new_from_cart(cart)
    new_order = self.new
    cart.line_items.each do |item|
      new_item = item.dup
      new_item.itemized = new_order
      new_item.quantity = item.quantity
      new_order.line_items << new_item
    end    
   if new_order.line_items.any?
     new_order
   else
     new_order.errors.add(:base, "Please check quantity available!")
     false
   end    
  end
  
  def shipping_same_as_billing
    billing_address && shipping_same
  end
  
  
  def copy_shipping_address
    shipping_address = billing_address.dup
    shipping_address.kind = "shipping"
    shipping_address.save
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
  
end
