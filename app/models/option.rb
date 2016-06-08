class Option < ApplicationRecord
  has_and_belongs_to_many :products
  has_many :option_values
  
  
  def remove_from_variants_and_delete
    product.variants.each do |variant|
      variant.options_values.where(option_id: self.id).destroy_all
    end
    destroy!
    product.reload
    product.variants.clean_up
  end
  
  def unique_variant_values
    option_values.with_stock.select(:value, :id).to_a.uniq(&:value)
  end
  
  def self.by_id
    order(id: :asc)
  end
end
