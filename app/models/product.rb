class Product < ApplicationRecord
  include Liquid::Rails::Droppable
  attr_accessor :sizes_list, :publishing_service, :product_view, :temporary_slug
  
  extend FriendlyId
  friendly_id :temporary_slug, use: [:slugged, :history]  
  
  include DateTimeScopes
  include RankedModel
  include Quantifiable

  PUBLISHING_CONDITIONS = {
    name_isnt_valid: "valid?",
    needs_a_description: "description.present?",
    check_price: "price_over_minimum?",
    check_quantity: "has_stock?",
    no_photo_present: 'photo.persisted?'
  }
  
  ranks :row_order
    
  has_one :photo, as: :photoable
  has_many :variants do
    def create_from_properties_and_options(properties_and_options, adding=false)
      array_of_properties = properties_and_options.keys
      array_of_options = prepare_multidimensional_options(properties_and_options)
      final_variants = construct_from_properties_and_multi_array(array_of_options, array_of_properties)
      clean_up
      clean_up_strays(array_of_properties.size) if adding
    end
    
    def add_from_properties_and_options(properties_and_options)
      self.create_from_properties_and_options(properties_and_options)
      deconstituted_options = self.deconstitute
      self.create_from_properties_and_options(deconstituted_options, true)
    end  
  end
  
  has_and_belongs_to_many :options
  
  validates_presence_of :name, :price_cents
  validates_uniqueness_of :name
  validates_length_of :name, minimum: 3, too_short: "Name is too short (min 3 characters)"
  validates_associated :variants
  
  monetize :price_cents, allow_nil: 'true'
  monetize :shipping_base_cents, allow_nil: 'true'
  monetize :international_shipping_base_cents, allow_nil: 'true'
  monetize :additional_shipping_per_item_cents, allow_nil: 'true'
  monetize :additional_international_shipping_per_item_cents, allow_nil: 'true'

  after_save :add_sizes, if: :sizes_list_present?

  accepts_nested_attributes_for :variants, :photo
  
  def photo
    super || NullPhoto.new
  end
  
  # you can probably be smarter and keep this out of
  # a model's code entirely
  # obviously at least extract it
  # SimpleDelegator is probably the way to go
  def method_missing(method, args={})
    if method == :bp_view
      @product_view ||= ProductView.new(args.merge({product: self}))
    else
      super
    end
  end
  
  def publishing_service
    # TODO: Possibly make all calls to publishing service external
    # Dependency Injection: 
    # PublishingService.new(product)
    @publishing_service ||= PublishingService.new(self, Product::PUBLISHING_CONDITIONS) 
  end
  
  
  def primary_image(size=nil)
    photo.image_url(size)
  end
    
  def sizes_list_present?
    sizes_list.present?
  end
  
  def add_sizes
    # create or find our option (sizes in this case)
    size_option = options.find_or_create_by(name: "Size")
    variants.create_from_properties_and_options({
     size_option => sizes_list
    })
  end
  
  def name_or_slug
    name.empty? ? slug : name
  end
  
  def publish!
    update(published: true, taken_down: false) if !self.published? && self.publishable? 
  end

  def publishable?
    publishing_service.valid?
  end

  
  def price_over_minimum?
    price_cents > 99
  end
    
  def least_expensive_variant
    variants.order(price_cents: :asc).first
  end
  
  def take_down!
    if self.published? && !taken_down?
      self.update(published: false, taken_down: true)
      true
    else
      false
    end
  end
  
  def not_taken_down?
    !taken_down?
  end
  
  
  # TODO: Move this (and corresponding Variants methods into a view object of some sorts (could be decorator/presenter too))
  def price_label
    variants.any? ? "Variants Control Price &#8595;" : "Price"
  end
  
  
  def price_disabled?
    variants.any?
  end
  
  def quantity_label
    variants.any? ? "Variants Control Quantity &#8595;" : "Quantity"
  end
  
  def inventory_label
    variants.any? ? "Variants Control Inventory &#8595;" : "Use Inventory?"
  end
  
  def inventory_disabled?
    variants.any?
  end
  
  def self.create_from_photo(photo_id)
    return unless photo = Photo.find(photo_id)
    product_name = photo.caption.present? ? photo.caption : "Product ##{Product.count + 1}"
    create({
      name: product_name,
      price_cents: 100,
      shipping_base_cents: 100,
      using_inventory: false,
      photo: photo
    })
  end
  
  def self.not_taken_down
    where(taken_down: false)
  end
  
  def self.taken_down
    where(taken_down: true)
  end
  
  def self.published
    where(published: true)
  end
  
  def self.status(state)
    self.public_send(state) if state.in?(['published', 'taken_down', 'all'])
  end
  
  def self.by_date
    order(updated_at: :desc)
  end  
  
  def self.by_relevance
    order(created_at: :desc)
  end
  
  def self.cheapest
    order(price_cents: :asc)
  end
  
  def self.most_expensive
    order(price_cents: :desc)
  end
  
  def self.by_price_range(price_range_in_cents)
    where(price_cents: price_range_in_cents)
  end
  
  def self.order_by(param)
    case param
    when 'relevance'
      self.by_relevance
    when 'newest'
      self.by_date
    when 'lowest_price'
      self.cheapest
    when 'highest_price'
      self.most_expensive
    else
      self.where(nil)
    end
  end 

  def self.new_since(time)
    where("updated_at > ?", time)
  end
  
  def self.by_week
    self.all.group_by do |product|
      product.created_at.beginning_of_week
    end.sort.to_h
  end

  def temporary_slug=(value)
    attribute_will_change!('temporary_slug') if temporary_slug != value
    @temporary_slug = value
  end
  
  def temporary_slug_changed?
    changed.include?('temporary_slug')
  end
  
  def should_generate_new_friendly_id?
    temporary_slug_changed?
  end
  # def self.with_visible_stock(cart)
  #   stocked.reject { |product| cart.number_of_products_inside(product.id, "product") >= product.quantity }
  # end


  
end
