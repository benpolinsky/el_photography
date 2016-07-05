unless Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['aws_access_key'],                        # required
      aws_secret_access_key: ENV['aws_access_secret'],                        # required
      region:                'us-west-2'                  # optional, defaults to 'us-east-1'
    }
    config.asset_host = "https://d32mcea23qtv9h.cloudfront.net/"
    config.fog_directory  = 'elpphotography'                          # required
  end
end