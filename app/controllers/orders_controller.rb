class OrdersController < ApplicationController
  respond_to :html, :js
  before_filter :find_order, except: [:new, :create]
  
  # create on new.  allows for tracking of abandoned orders
  def new
    @order = Checkout.new(@cart, session).order
    @billing_address = @order.addresses.find_or_initialize_by(kind: "billing")
    @shipping_address = @order.addresses.find_or_initialize_by(kind: "shipping")
    if @order.line_items.any?
      session[:order_id] = @order.id
    else
      redirect_to store_path, notice: "No items in your cart!"
    end
  end

  # handles checkoutflow
  
  def update
    self.method(params[:current_step]).call if params[:current_step].in? ['process_address', 'process_payment']
  end
  
  # Setup + Render
  def enter_address

  end
  
  # Receive + Process
  def process_address
    if @order.update_attributes(order_params) && @order.both_addresses_filled?
      redirect_to [:enter_payment, @order]
    else
      render :new
    end
  end
  
  # Setup + Render
  def enter_payment
  end
  
  # Receive + Process
  def process_payment
    card = params[:stripeToken]
    if @order.update_attributes(order_params)
      if payment = Payment.new(@order, card).pay
        redirect_to [:payment_accepted, @order]
      else
        render :enter_payment, notice: "Sorry, something went wrong"
      end
    else
      render :enter_payment
    end
  end
  
  def payment_accepted
  end
  
  
  private

  def find_order
    @order = Order.find(params[:id])
  end
  
  def order_params
    params.require(:order).permit(:id, :payment_method, :shipping_same, 
      :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, 
      :credit_card_security_code, addresses_attributes: [:id, :kind, :street_line_1, 
      :street_line_2, :stree_line_3, :country, :city, :state, :zip_code])
  end
  
  def proceed_to_payment
    
  end
end