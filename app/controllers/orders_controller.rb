class OrdersController < ApplicationController
  respond_to :html, :js
  before_filter :find_order, except: [:new, :create, :success, :cancel]
  
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
    @order.calculate_totals
    if @order.update_attributes(order_params)
      if @order.payment_method == "stripe"
        # damnit this pay abstraction isn't working:
        if payment = Payment.new(@order, card).pay
          redirect_to [:payment_accepted, @order]
        else
          render :enter_payment, notice: "Sorry, something went wrong"
        end
      else
        payment_response = Payment.new(@order).pay
        pp payment_response.inspect
        if payment_response.try(:redirect_uri)
          redirect_to(payment_response.redirect_uri)
        else
          render :enter_payment, notice: "Sorry, something went wrong"
        end
      end
    else
      byebug
      render :enter_payment
    end
  end
  
  def success
    @order = Order.find(session[:order_id])
    payment = Payment.new(@order)
    info = payment.checkout(params[:token], params[:PayerID]).payment_info.first
    if info.payment_status == "Completed"
      pp info
      redirect_to [:payment_accepted, @order]
    else
      # order failed
      redirect_to [:enter_payment, @order], notice: "Sorry, something went wrong with you PayPal Payment."
    end
  end
  
  def cancel
  end
  
  def payment_accepted
    checkout = Checkout.new(@cart, session)
    checkout.remove_cart
    checkout.clear_order
  end
  
  
  private

  def find_order
    @order = Order.find(params[:id])
  end
  
  def order_params
    params.require(:order).permit(:id, :payment_method, :shipping_same, 
      :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, 
      :credit_card_security_code, addresses_attributes: [:id, :first_name, 
      :last_name, :kind, :street_line_1, :street_line_2, :stree_line_3, 
      :country, :city, :state, :zip_code])
  end
  
  def proceed_to_payment  
  end
end