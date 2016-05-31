# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :password_confirmation, :credit_card_number, :credit_card_exp_month, :credit_card_exp_year, :credit_card_security_code]
