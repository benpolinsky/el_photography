class Admin::OrdersController < AdminController
  before_filter :find_order

  def index
    @orders = Order.all
  end

  def show
  end

  private
  def find_order
    @order = Order.find(params[:id]) if params[:id]
  end
end