class Admin::OrdersController < AdminController
  before_filter :find_order

  def index
    @orders = Order.all
  end

  private
  def find_order
    @model = Orders.find(params[:id]) if params[:id]
  end
end