class OrderMailer < ApplicationMailer
  include AddressesHelper
  helper :addresses
  default from: 'orders@elliotpolinsky.com'


  def self.send_completed(order_id)
    order_shipped(order_id).deliver_later
    new_order(order_id).deliver_later
  end
  
    
  def order_shipped(order_id)
    @order = Order.find(order_id)
    mail(to: @order.contact_email, 
        from: 'Elliot Polinsky Photography <orders@elliotpolinsky.com>', 
        subject: "Your Order Has Shipped!")
  end
  
  def new_order(order_id)
    @order = Order.find(order_id)
    mail(to: 'elliotpo@gmail.com', 
        from: 'Elliot Polinsky Photography <orders@elliotpolinsky.com>', 
        subject: "New Order Received")
  end
  
  def user_purchase(order_id)
    @order = Order.find(order_id)
    mail(to: @order.contact_email, 
        from: 'Elliot Polinsky Photography <orders@elliotpolinsky.com>', 
        subject: "Your Purchase from Elliot Polinsky Photography")
  end
  
end