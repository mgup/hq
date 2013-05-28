source 'https://rubygems.org'

gem 'rails', '4.0.0.rc1'
gem 'mysql2'
gem 'coveralls', require: false

group :assets do
  gem 'sass-rails', '4.0.0.rc1'
  gem 'coffee-rails'

  gem 'therubyracer', platforms: :ruby

  gem 'uglifier'
end

gem 'jquery-rails'
gem 'turbolinks'

gem 'jbuilder'
gem 'rails-i18n'
gem 'simple-navigation'
gem 'vmstat'
gem 'devise', github: 'plataformatec/devise', branch: :rails4
gem 'devise-i18n'
gem 'rack-mini-profiler'

# В терминале: bundle config local.ui /Users/storkvist/Sites/mgup/ui
gem 'ui', github: 'mgup/ui', branch: :master

group :development do
  gem 'thin'
  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'

  gem 'capistrano'
  gem 'rvm-capistrano'
end

group :test do
  gem 'faker'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end