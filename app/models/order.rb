class Order < ApplicationRecord
  include AASM
  attr_accessor :shipping_same
    
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
      transitions from: :email_added, to: :billing_added, if: :billing_address_added
    end
    
    event :add_shipping do
      transitions from: :email_added, to: :shipping_added
    end
    
    event :initialize_payment do
      transitions from: :shipping_added, to: :payment_added
    end
    
    event :accept_payment do
      transitions from: :payment_added, to: :payment_accepted
      transitions from: :payment_added, to: :payment_failed # if failed
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
  
  def billing_address_added
    billing_address.present?
  end
  
  def shipping_same_as_billing
    billing_address && shipping_same
  end
  
  
  def copy_shipping_address
    shipping_address = billing_address.dup
    shipping_address.kind = "shipping"
    shipping_address.save
  end
  
  
end
