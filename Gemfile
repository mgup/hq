source 'https://rubygems.org'

gem 'rails'
gem 'mysql2'
gem 'coveralls', require: false

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  gem 'therubyracer', platforms: :ruby

  gem 'uglifier'
end

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'

gem 'jbuilder'
gem 'rails-i18n'
gem 'russian'
gem 'simple-navigation'
gem 'vmstat'
gem 'devise'
gem 'devise-i18n'
gem 'dalli'
gem 'rack-mini-profiler'
gem 'cancan'
gem 'bootstrap-datepicker-rails'
gem 'kaminari'
gem 'prawn'
gem 'prawn_rails'
gem 'rqrcode'
gem 'prawn-qrcode'
gem 'squeel'
gem 'nested_form', github: 'ryanb/nested_form'
gem 'hairtrigger'

# В терминале: bundle config local.ui /Users/storkvist/Sites/mgup/ui
# gem 'ui', github: 'mgup/ui', branch: :master
# В терминале: bundle config local.morpher /Users/storkvist/Sites/mgup/morpher
gem 'morpher', github: 'mgup/morpher', branch: :master

group :development do
  gem 'thin'
  #gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'brakeman', require: false
  gem 'rails-erd'

  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'sextant'
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'bullet'
  gem 'meta_request'
end

group :test do
  gem 'faker'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fuubar'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end