class OrdersController < ApplicationController

  def new
    @order = Order.new_from_cart(@cart) # this needs to find once any info is saved
    if @order
      @billing_address = @order.addresses.find_or_build_by(kind: "billing")
      @shipping_address = @order.addresses.find_or_build_by(kind: "shipping")
    else
      redirect_to store_path
    end
  end

  private

end