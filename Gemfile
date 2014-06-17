source 'https://rubygems.org'

gem 'rails'
gem 'mysql2'
gem 'coveralls', require: false

gem 'sass-rails'
gem 'bootstrap-sass'
gem 'coffee-rails'

gem 'therubyracer', platforms: :ruby
gem 'uglifier'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'jquery-ui-rails'

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
gem 'prawn' #, git: 'git://github.com/prawnpdf/prawn', branch: 'master'
gem 'prawn_rails'
# gem 'rqrcode'
# gem 'squeel'
gem 'chunky_png'
gem 'barby'
gem 'nested_form' #, github: 'ryanb/nested_form'
gem 'hairtrigger'
gem 'axlsx_rails'
gem 'acts_as_xlsx'
gem 'ace-rails-ap'
gem 'unicode'
gem 'spreadsheet'
#gem 'jquery-ui-rails'
#gem 'jquery-multiselect-rails', git: 'git://github.com/arojoal/jquery-multiselect-rails.git'

# В терминале: bundle config local.ui /Users/storkvist/Sites/mgup/ui
# gem 'ui', github: 'mgup/ui', branch: :master
# В терминале: bundle config local.morpher /Users/storkvist/Sites/mgup/morpher
# gem 'morpher', github: 'mgup/morpher', branch: :master

gem 'airbrake'
gem 'dotenv-rails'
# gem 'tiny_tds'
#gem 'activerecord-sqlserver-adapter'

gem 'httparty'
gem 'sidekiq'
gem 'sidetiq'
gem 'sinatra', require: nil

group :production do
  gem 'skylight'
end

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
  gem 'capistrano-sidekiq'
end

group :test do
  gem 'faker'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'codeclimate-test-reporter', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rubocop', require: false
end
