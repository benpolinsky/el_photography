source 'https://rubygems.org'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'modulejs-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-infinite-pages'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks

#gem 'turbolinks', '~> 5.x'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'jbuilder', '~> 2.0'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bootstrap', '~> 4.0.0.alpha3'
#gem 'bootstrap_form'
gem 'gretel', github: 'craig1410/gretel', branch: 'dep_alias_method_chain'
gem "font-awesome-rails"
gem "selectize-rails"

gem 'figaro'
gem 'parsley-rails'
gem "flutie"
gem 'trix'
gem 'country_select'

gem 'paypal-express'
gem 'stripe'
gem 'money-rails'
gem 'friendly_id', '~> 5.1.0'
gem 'aasm'
gem 'hashids'
gem 'seed_dump'
gem "autoprefixer-rails"
gem 'acts-as-taggable-on', github: 'cireficc/acts-as-taggable-on' # rails 5 (4/25/16

# images + media
gem 'rmagick'
gem 'carrierwave'
gem "fog"
gem 'dropzonejs-rails'

gem 'active_link_to'
gem 'best_in_place', '~> 3.0.1'
gem 'ranked-model'
gem 'kaminari', github: 'amatsuda/kaminari' # until rails 5 fix https://github.com/amatsuda/kaminari/issues/774

gem 'devise', git: 'https://github.com/plataformatec/devise.git', tag: "master"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails.git", branch: "master"
  gem "rspec-core", git: "https://github.com/rspec/rspec-core.git", branch: "master"
  gem "rspec-support", git: "https://github.com/rspec/rspec-support.git", branch: "master"
  gem "rspec-expectations", git: "https://github.com/rspec/rspec-expectations.git", branch: "master"
  gem "rspec-mocks", git: "https://github.com/rspec/rspec-mocks.git", branch: "master"
  gem 'rails-controller-testing'
  gem 'byebug'
  gem 'faker'
  gem 'timecop'
  gem "factory_girl_rails", "~> 4.0"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 3.0'
  # gem 'listen', '~> 3.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
