require 'rollbar/rails'
Rollbar.configure do |config|
  config.access_token = 'c2cbae55b8e543e785d35ea7f72e909b'

  config.enabled = false unless Rails.env.production?

  # By default, Rollbar will try to call the `current_user` controller method
  # to fetch the logged-in user object, and then call that object's `id`,
  # `username`, and `email` methods to fetch those properties. To customize:
  config.person_method = 'current_user'
  config.person_id_method = 'id'
  config.person_username_method = 'full_name'
  config.person_email_method = 'email'

  # If you want to attach custom data to all exception and message reports,
  # provide a lambda like the following. It should return a hash.
  # config.custom_data_method = lambda { {:some_key => "some_value" } }

  # Add exception class names to the exception_level_filters hash to
  # change the level that exception is reported at. Note that if an exception
  # has already been reported and logged the level will need to be changed
  # via the rollbar interface.
  # Valid levels: 'critical', 'error', 'warning', 'info', 'debug', 'ignore'
  # 'ignore' will cause the exception to not be reported at all.
  # config.exception_level_filters.merge!('MyCriticalException' => 'critical')
  #
  # You can also specify a callable, which will be called with the exception instance.
  # config.exception_level_filters.merge!('MyCriticalException' => lambda { |e| 'critical' })
  %w(ActionController::InvalidAuthenticityToken
     ActionController::RoutingError
     AbstractController::ActionNotFound
     ActiveRecord::RecordNotFound).each do |exception_name|
    config.exception_level_filters.merge!(exception_name => 'ignore')
  end

  # Enable asynchronous reporting (uses girl_friday or Threading if girl_friday
  # is not installed)
  # config.use_async = true
  # Supply your own async handler:
  # config.async_handler = Proc.new { |payload|
  #  Thread.new { Rollbar.process_payload(payload) }
  # }

  # Enable asynchronous reporting (using sucker_punch)
  # config.use_sucker_punch

  # Enable delayed reporting (using Sidekiq)
  config.use_sidekiq
  # You can supply custom Sidekiq options:
  # config.use_sidekiq 'queue' => 'default'
end