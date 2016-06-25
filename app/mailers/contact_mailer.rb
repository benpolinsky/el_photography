class ContactMailer < ApplicationMailer
  def contact_elliot(email, name, message)
    @email = params["email"]
    @name = params["name"]
    @message = params["body"]    
    mail to: "benjamin.polinsky@gmail.com"

  end
end
