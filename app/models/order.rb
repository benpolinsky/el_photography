class Order < ApplicationRecord
  has_many :line_items, as: :itemized, dependent: :delete_all
  has_many :addresses do
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
end
