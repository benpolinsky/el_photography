module Quantifiable

  extend ActiveSupport::Concern

  included do
   validates_numericality_of :quantity, allow_nil: true, only_integer: true, greater_than_or_equal_to: 0
  end
  
  def only_one?
    quantity == 1 
  end
  
  def deduct_quantity(amount=1)
    if using_inventory?
      quantity > amount ? self.update(quantity: quantity - amount) : self.out_of_stock!
    end
  end
  
  
  def has_stock?
    !using_inventory || quantity.to_i > 0
  end
  
  def out_of_stock!
    update_attributes(state: 'out_of_stock', quantity:0)
  end
  
  
  # this is more appropriately "quantity_not_locked" or something to that effect
  def available_quantity
    if using_inventory
      quantity
    else
      Float::INFINITY # maybe this'll work
    end
  end
  
  module ClassMethods

    def stocked
      where("quantity > ?", 0)
    end
  
  end
  
end