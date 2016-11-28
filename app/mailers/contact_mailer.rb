class ContactMailer < ApplicationMailer
  layout 'mailer'
  include MailHelper
  include AddressesHelper

  helper :mail  
  helper :addresses
  
  default from: 'contact@elliotpolinsky.com'
  def contact_elliot(email, name, message)
    @email = email
    @name = name
    @message = message
    mail to: "elliotpo@gmail.com"
  end
end
