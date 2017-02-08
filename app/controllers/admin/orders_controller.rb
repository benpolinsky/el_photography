class Admin::OrdersController < AdminController
  before_action :find_order

  def index
    @q = Order.ransack(params[:q])
    if params[:all].present?
      @orders = @q.result.by_date.page(params[:page])
    else
      @orders = @q.result.completed.by_date.page(params[:page])
    end
  end

  def show
  end


  def ship
    if @order.ship!
      OrderMailer.order_shipped(@order.id).deliver_now
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