class OrdersController < ApplicationController
  respond_to :html, :js
  before_action :find_order, except: [:new, :create, :success, :cancel]
  
  # create on new.  allows for tracking of abandoned orders
  def new
    @order = Checkout.new(@cart, session).order
    find_addresses
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
    if @order.process_addresses(order_params)
      redirect_to [:enter_payment, @order]
    else
      find_addresses
      @errors = error_list_for(@order)
      render :new
    end
  end
  
  # Setup + Render
  def enter_payment
  end

  def process_payment
    @order.process_payment(order_params, params[:stripeToken])
    if @order.status == 'payment_accepted' 
      redirect_to @order.payment.successful_payment_path
    else
      render :enter_payment, notice: "Sorry something went wrong"
    end
  end
  
  # Receive + Process
  # def process_payment
 #    payment_response = @order.process_payment(order_params, params[:stripeToken])
 #
 #    if @order.payment_method == "paypal" && payment_response.try(:redirect_uri)
 #      redirect_to(payment_response.redirect_uri)
 #    elsif @order.payment_method == "stripe" && payment_response
 #      redirect_to [:payment_accepted, @order]
 #    else
 #      render :enter_payment, notice: "Sorry, something went wrong"
 #    end
 #  end
  
 
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
    @order = Order.friendly.find(params[:id])
  end
  
  def find_addresses
    @billing_address = @order.addresses.find_or_initialize_by(kind: "billing")
    @shipping_address = @order.addresses.find_or_initialize_by(kind: "shipping")
  end
  
  def order_params
    params.require(:order).permit(:id, :payment_method, :shipping_same, 
      :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, 
      :credit_card_security_code, :contact_email, 
      addresses_attributes: [:id, :first_name, 
      :last_name, :kind, :street_line_1, :street_line_2, :stree_line_3, 
      :country, :city, :state, :zip_code])
  end
  
  def proceed_to_payment  
  end
end