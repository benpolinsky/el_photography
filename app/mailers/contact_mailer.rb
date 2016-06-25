class ContactMailer < ApplicationMailer
  def contact_elliot(params)
    @email = params["email"]
    @name = params["name"]
    @message = params["body"]    
    mail to: "benjamin.polinsky@gmail.com"

  end
end
