class Admin::OrdersController < AdminController
  before_filter :find_order

  def index
    @orders = Order.all
  end

  def show
  end


  def ship
    if # it workds
      # great
    else
      @resource = @order
      render :show
    end
  end
  private
  def find_order
    @order = Order.friendly.find(params[:id]) if params[:id]
  end
end