CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:              'AWS',                        
    aws_access_key_id:     ENV['aws_access_key'],                        # required
    aws_secret_access_key: ENV['aws_access_secret'],                        # required
    region:                'us-west-2'               # optional, defaults to nil
  }
  config.fog_directory  = 'elpphotography'                     # required
end

