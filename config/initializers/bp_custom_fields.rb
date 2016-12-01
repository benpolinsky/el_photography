BpCustomFields.configure do |config|
  config.controller_layout = "admin"
  config.carrierwave_upload_method = ENV['carrierwave_storage_method'].to_sym
end