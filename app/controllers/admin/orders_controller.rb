class Admin::OrdersController < AdminController
  before_filter :find_order

  def index
    @orders = Order.all
  end

  def show
  end


  def ship
    if @order.ship
      # email buyer
      redirect_to [:admin, @order], notice: "Order Marked as Shipped and Buyer Notified"
    else
      @resource = @order
      redirect_to [:admin, @order], notice: "Sorry, we couldn't mark this as shipped..."
    end
  end
  
  
  private
  def find_order
    @order = Order.friendly.find(params[:id]) if params[:id]
  end
end