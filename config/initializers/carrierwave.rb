unless Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['aws_access_key'],                        # required
      aws_secret_access_key: ENV['aws_access_secret'],                        # required
      region:                'us-west-2'               # optional, defaults to nil
    }
    config.asset_host = ENV['cdn_asset_host']
    config.fog_directory  = 'elpphotography'                     # required
  end
end

