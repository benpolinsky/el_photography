class ContactMailer < ApplicationMailer
  def contact_elliot(params)
    @email = params["email"]
    @name = params["name"]
    @message = params["body"]    
    mail to: "elliot@elliot.com"

  end
end
