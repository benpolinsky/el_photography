class ApplicationMailer < ActionMailer::Base
  include MailHelper
  include AddressesHelper

  helper :mail  
  helper :addresses
  
  default from: 'contact@elliotpolinsky.com'
  layout 'mailer'
end
