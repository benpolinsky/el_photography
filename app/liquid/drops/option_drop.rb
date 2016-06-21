class OptionDrop < Liquid::Rails::Drop
  attributes :name, :unique_variant_values
  belongs_to :product
  has_many :option_values
  
  # def unique_variant_values
  #   # Liquid::Rails::CollectionDrop.new(option_values.with_stock.select(:value, :id).to_a.uniq(&:value))
  #   Liquid::Rails::CollectionDrop.new(option_values.with_stock.select(:value, :id).to_a.uniq(&:value))
  # end
end