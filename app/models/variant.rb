class Variant < ApplicationRecord
    include Liquid::Rails::Droppable
  using ArrayExtensions
  include RankedModel
  include Quantifiable
  ranks :row_order
  
  belongs_to :product
  has_many :options, through: :product
  has_and_belongs_to_many :option_values, dependent: :destroy
  
  monetize :price_cents
  monetize :shipping_base_cents
  monetize :international_shipping_base_cents, disable_validation: true
  monetize :additional_shipping_per_item_cents, disable_validation: true
  monetize :additional_international_shipping_per_item_cents, disable_validation: true

  validates_presence_of :product
  delegate :primary_image, to: :product
  
  # convenience methods
  def only_one?
    quantity == 1
  end
  
  def quantity_present?
    quantity.present?
  end

  def name
    grouped_variant_values.sort.to_h.values.flatten.map(&:value).join(" ")
  end
  
  def short_name
    "#{name[0..4]}..."
  end
  
  def name_with_product
    "#{product.name} #{self.name}"
  end

  
  def unique_key
    grouped_variant_values.sort.to_h.values.flatten.map(&:id).join("_")
  end

  def taken_down?
    product.taken_down?
  end
  
  def has_stock?
    quantity.to_i > 0
  end
  
  def out_of_stock!
    update_attributes(state: 'out_of_stock', quantity:0)
  end
  
  def deduct_quantity(amount=1)
    quantity > amount ? self.update(quantity: quantity - amount) : self.out_of_stock!
  end
  
  def price_label
    "Price"
  end
  
  def price_disabled?
    false
  end
  

  
  def self.with_quantity(amount=0)
    where("quantity > ? OR using_inventory = false", amount)
  end
  
  def self.with_value_name(value_name)
    self.joins(:option_values).where('option_values.value' => value_name)
  end
  
  def self.find_by_product_option(option_id)
    self.joins(:option_values).where('option_values.option_id' => option_id)
  end
  
  # Clean up any variants with the same name, keeping the older variants
  def self.clean_up
    variants = self.all.group_by {|variant| variant.name }
    variants.values.each do |duplicates|
      one_to_return = duplicates.sort!.shift
      duplicates.each {|d| d.destroy}
      one_to_return.destroy if one_to_return.name.blank?
    end
  end
  
  def self.clean_up_strays(number_of_properties)
    if number_of_properties == 0
      self.delete_all
    else
      self.all.each do |variant|
        variant.delete unless number_of_properties == variant.option_values.size
      end
    end
  end
  
  def self.deconstitute
    final_object = {}
    grouped_values = self.all.map { |v| v.option_values}.flatten.group_by(&:option)
    grouped_values.each do |group|
      grouped_values.keys.each do |product_option|
        final_object[product_option] = grouped_values[product_option].sort_by(&:id).map(&:value).uniq.join(", ")
      end
    end
    final_object
  end
  
  
  private
  
  def set_price_to_products
    self.price = product.price if self.price == 0 && product.present?
  end
  
  def set_quantity_to_products
    self.quantity = product.quantity if self.quantity == 0 && self.product.present?
  end
  
  def self.prepare_multidimensional_options(properties_and_options)
    array_of_options = []
    properties_and_options.each {|k,v| array_of_options << v.split(", ") }
    array_of_options
  end
  
  

  # Then we get an array of each set of variants we want
  # We loop through each, and create a new variant
  # we loop through the properties corresponding to the OptionValue
  # and return each variant in an array
  def self.construct_from_properties_and_multi_array(array_of_options, array_of_properties)
    array_of_options.first.multiply(*array_of_options[1..-1]).each_with_index do |variation_properties, index|
      new_variant = self.new(quantity: 1, price: 1.00, shipping_base: 0.50)
      array_of_properties.size.times do |t|
        property_value = variation_properties[t]
        property = array_of_properties[t]
        option_value = OptionValue.find_or_create_by(value: property_value, option_id: property.id)
        option_value.variants << new_variant
#        option_value.variants.clean_up_strays(array_of_properties.size) if array_of_properties.size == t
      end
    end
  end
  
  def grouped_variant_values
    option_values.group_by {|variant_value| variant_value.option_id}
  end
  
end
