# This is a CheckoutController, time to change it....
# much will make sense
class OrdersController < ApplicationController
  respond_to :html, :js
  before_action :find_order, except: [:new, :create, :cancel]
  protect_from_forgery :except => :webhook
  
  # create on new.  allows for tracking of abandoned orders
  
  def new
    @order = create_or_find_from_cart
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

  # order.reload is nearly always unnecessary
  # let's rely on the checkout's response
  def process_payment
    @order.update_with_totals(order_params)
    processor = new_processor(@order, params[:stripeToken])
    checkout_response = checkout(processor).pay!
    
    if checkout_response[:status] == "succeeded"
      successful_order
    elsif checkout_response[:status] == "pending_confirmation" 
      @order.pending_confirmation!
      redirect_to checkout_response[:second_step_url]
    else
      failed_order
    end
  end
  
  def success
    processor = new_processor(@order)
    checkout_response = checkout(processor).complete!(token: params[:token], payer_id: params[:PayerID])
    if checkout_response[:status] == "Success" # standardize these
      successful_order
    else
      failed_order
    end
  end
  
  def cancel
    # mark order as cancelled
  end
  
  def payment_accepted
    @cart.destroy
    session[:cart_id] = nil
    session[:order_id] = nil
  end
  
  
  private
  
  def successful_order
    @order.accept_payment!
    @order.update_purchased_at
    OrderMailer.send_completed(@order.id)
    redirect_to [:payment_accepted, @order]
  end
  
  def failed_order
    @order.fail_payment!
    redirect_to [:enter_payment, @order], notice: "Sorry something went wrong"
  end
  
  def find_order
    if params[:id]
      @order = Order.friendly.find(params[:id])
    else
      @order = Order.find(session[:order_id])
    end
  end

  # The following methods were jammed into the Checkout class
  # They're all CRUD operations w/r/t orders and carts
  # Because carts are largely managed through the session (currently)
  # there's an argument to be made sticking these in a controller is ok...
  
  def create_or_find_from_cart
    @order = session[:order_id].present? ? find_order_from_cart : create_order_from_cart
    if @order && @order.line_items.any?
      @order.skip_email_validation = true
      @order.save
      @order
    elsif @order
      @order.errors.add(:base, "Please check quantity available!")
      false
    else
      false
    end     
  end
  

  def find_order_from_cart
    @order = Order.friendly.find(session[:order_id]) 
    if @order && @order.updated_at > @cart.updated_at
      @order
    elsif @order && @order.updated_at < @cart.updated_at
      update_order_from_cart
    end
  end
  
  def create_order_from_cart
    @order = Order.new
    @order.import_line_items(@cart)
  end
  
  def update_order_from_cart
    @order.line_items.delete_all
    @order.import_line_items(@cart)
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
      :last_name, :kind, :street_line_1, :street_line_2, :street_line_3, 
      :country, :city, :state, :zip_code])
  end
  
  def new_processor(order, card=nil)
    "#{order.payment_method}_payment_processor".camelize.safe_constantize.new({
      amount_to_pay: order.grand_total,
      description: order.description,
      card: params[:stripeToken]
    })
  end
  
  def checkout(processor)
    Checkout.new({
      cart: @cart, 
      processor: processor
    })
  end
end