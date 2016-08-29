class ContactMailer < ApplicationMailer
  default from: 'contact@elliotpolinsky.com'
  def contact_elliot(email, name, message)
    @email = email
    @name = name
    @message = message
    mail to: "benjamin.polinsky@gmail.com"
  end
end
