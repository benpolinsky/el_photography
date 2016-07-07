source 'https://rubygems.org'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end


gem 'rails', '>= 5.0.0.beta3', '< 5.1'
gem 'pg', '~> 0.18'
gem 'puma'
gem 'sidekiq'
gem 'redis', '~> 3.0'

# assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'modulejs-rails'
gem 'bootstrap', '~> 4.0.0.alpha3'
gem "font-awesome-rails"
gem "autoprefixer-rails"

# Setup/config
gem 'figaro'
gem "flutie"
gem 'browser'

# forms
gem 'country_select'
gem 'best_in_place', '~> 3.0.1'
gem 'ransack', github: 'activerecord-hackery/ransack'

# Payments/Money
gem 'paypal-express'
gem 'stripe'
gem 'money-rails'

# js libraries
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-infinite-pages'
gem 'parsley-rails'
gem "selectize-rails"


gem 'jbuilder', '~> 2.0'

# templating / user customization
gem 'liquid-rails', github: "benpolinsky/liquid-rails" # until master supports kaminari 0.17.0
gem 'bp_custom_fields', github: 'benpolinsky/bp_custom_fields' 
gem 'ace-rails-ap', github: 'benpolinsky/ace-rails-ap' # until master fixes 404 errors due to snippets

# images + media
gem 'rmagick'
gem 'carrierwave', require: false
gem "fog"
gem 'dropzonejs-rails'

# Model extends/includes
gem 'friendly_id', '~> 5.1.0'
gem 'aasm'
gem 'acts-as-taggable-on', github: 'cireficc/acts-as-taggable-on' # rails 5 (4/25/16
gem 'ranked-model'
gem 'hashids'

gem 'gretel', github: 'craig1410/gretel', branch: 'dep_alias_method_chain'
gem 'seed_dump'
gem 'active_link_to'

gem 'kaminari', :git => "git://github.com/amatsuda/kaminari.git", :branch => 'master'

gem 'devise', git: 'https://github.com/plataformatec/devise.git', tag: "master"

gem 'airbrake', '~> 5.4'
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
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-ssh-doctor', '~> 1.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
ruby '2.3.1'