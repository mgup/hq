class CustomPublicExceptions < ActionDispatch::PublicExceptions
  def call(env)
    case env['PATH_INFO'][1..-1]
    when '404', '500'
      Rails.application.routes.call(env)
    else
      super
    end
  end
end
