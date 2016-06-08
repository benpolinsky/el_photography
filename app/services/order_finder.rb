class OrderFinder
  attr_reader :order_id, :cart
  def initialize(args)
    @order_id = args[:order_id]
    @cart = args[:cart]
  end
  
  def retrieve
    create_or_find_from_cart
  end
  
  private
  
  def create_or_find_from_cart
    @order = order_id.present? ? find_order_from_cart : create_order_from_cart
    if @order && @order.line_items.any?
      @order.skip_email_validation = true
      @order.save
    elsif @order
      @order.errors.add(:base, "Please check quantity available!")
      @order = NullOrder.new
    end
    @order
  end
  

  def find_order_from_cart
    @order = Order.friendly.find_by(id: order_id) 
    if @order && @order.updated_at > cart.updated_at
      @order
    elsif @order && @order.updated_at < cart.updated_at
      update_order_from_cart
    else
      create_order_from_cart
    end
  end
  
  def create_order_from_cart
    @order = Order.new
    @order.import_line_items(cart)
  end
  
  def update_order_from_cart
    @order.line_items.delete_all
    @order.import_line_items(cart)
  end
  
end