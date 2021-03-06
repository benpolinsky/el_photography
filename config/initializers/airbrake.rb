Airbrake.configure do |c|
  # You must set both project_id & project_key. To find your project_id and
  # project_key navigate to your project's General Settings and copy the values
  # from the right sidebar.
  # https://github.com/airbrake/airbrake-ruby#project_id--project_key
  c.project_id = 126662
  c.project_key = '263012a16d2f808eb2b0a4d5f7739c03'

  # Configures the root directory of your project. Expects a String or a
  # Pathname, which represents the path to your project. Providing this option
  # helps us to filter out repetitive data from backtrace frames and link to
  # GitHub files from our dashboard.
  # https://github.com/airbrake/airbrake-ruby#root_directory
  c.root_directory = Rails.root

  # By default, Airbrake Ruby outputs to STDOUT. In Rails apps it makes sense to
  # use the Rails' logger.
  # https://github.com/airbrake/airbrake-ruby#logger
  c.logger = Rails.logger

  # Configures the environment the application is running in. Helps the Airbrake
  # dashboard to distinguish between exceptions occurring in different
  # environments. By default, it's not set.
  # NOTE: This option must be set in order to make the 'ignore_environments'
  # option work.
  # https://github.com/airbrake/airbrake-ruby#environment
  c.environment = Rails.env

  # Setting this option allows Airbrake to filter exceptions occurring in
  # unwanted environments such as :test. By default, it is equal to an empty
  # Array, which means Airbrake Ruby sends exceptions occurring in all
  # environments.
  # NOTE: This option *does not* work if you don't set the 'environment' option.
  # https://github.com/airbrake/airbrake-ruby#ignore_environments
  c.ignore_environments = %w(test development)

  # A list of parameters that should be filtered out of what is sent to
  # Airbrake. By default, all "password" attributes will have their contents
  # replaced.
  # https://github.com/airbrake/airbrake-ruby#blacklist_keys
  c.blacklist_keys = [/password/i, /credit/i]
end