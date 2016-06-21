class OptionValue < ApplicationRecord
  include Liquid::Rails::Droppable
  belongs_to :option
  has_and_belongs_to_many :variants  
  validates :option, presence: true
  
  
  def self.with_stock
    joins(:variants).where("variants.quantity > ?", 0).distinct
  end
  
end
