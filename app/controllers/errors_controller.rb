# Контроллер для вывода страниц с сообщениями об ошибках.
class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def error404
    render status: :not_found
  end

  def error500
    @exception = env['action_dispatch.exception']

    text = "#{@exception.to_s}\n"
    text += "#{env['REQUEST_METHOD']}: http://#{env['HTTP_HOST']}#{env['REQUEST_PATH']}#{"?#{env['QUERY_STRING']}" if env['QUERY_STRING'].size > 1}\n"
    if signed_in?
      text += "#{current_user.full_name} (#{current_user.phone}, #{current_user.email})"
    end

    require 'telegram/bot'
    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
      # bot.api.sendMessage(chat_id: ENV['TELEGRAM_CHAT_ID'], text: text)
      # bot.api.sendMessage(chat_id: ENV['TELEGRAM_CHAT_ID'], text: env.keys.inspect)
      bot.api.sendMessage(chat_id: ENV['TELEGRAM_CHAT_ID'], text: @exception.backtrace[0..10].join("\n"))

      [
        "SERVER_SOFTWARE", "SERVER_NAME",
        "rack.input", "rack.version", "rack.errors", "rack.multithread",
        "rack.multiprocess", "rack.run_once",
        "REQUEST_METHOD", "REQUEST_PATH", "PATH_INFO", "REQUEST_URI", "HTTP_VERSION",
        "HTTP_HOST", "HTTP_CONNECTION", "HTTP_CACHE_CONTROL", "HTTP_ACCEPT",
        "HTTP_USER_AGENT", "HTTP_REFERER", "HTTP_ACCEPT_ENCODING",
        "HTTP_ACCEPT_LANGUAGE", "HTTP_COOKIE", "GATEWAY_INTERFACE", "SERVER_PORT",
        "QUERY_STRING", "SERVER_PROTOCOL",
        "rack.url_scheme", "SCRIPT_NAME", "REMOTE_ADDR", "async.callback",
        "async.close", "ORIGINAL_FULLPATH", "ORIGINAL_SCRIPT_NAME",
        "action_dispatch.routes", "action_dispatch.parameter_filter",
        "action_dispatch.redirect_filter", "action_dispatch.secret_token", "action_dispatch.secret_key_base", "action_dispatch.show_exceptions", "action_dispatch.show_detailed_exceptions", "action_dispatch.logger", "action_dispatch.backtrace_cleaner", "action_dispatch.key_generator", "action_dispatch.http_auth_salt", "action_dispatch.signed_cookie_salt", "action_dispatch.encrypted_cookie_salt", "action_dispatch.encrypted_signed_cookie_salt", "action_dispatch.cookies_serializer", "action_dispatch.cookies_digest", "ROUTES_48103960_SCRIPT_NAME", "rack.request.cookie_hash", "rack.request.cookie_string", "HTTP_IF_MODIFIED_SINCE", "HTTP_IF_NONE_MATCH", "action_dispatch.request_id", "action_dispatch.remote_ip", "rack.session", "rack.session.options", "warden", "action_dispatch.request.path_parameters", "action_controller.instance", "action_dispatch.request.content_type", "action_dispatch.request.request_parameters", "rack.request.query_string", "rack.request.query_hash", "action_dispatch.request.query_parameters", "action_dispatch.request.formats", "action_dispatch.cookies", "action_dispatch.request.unsigned_session_cookie", "action_dispatch.exception", "action_dispatch.original_path", "action_dispatch.request.parameters"].each do |key|
        bot.api.sendMessage(chat_id: ENV['TELEGRAM_CHAT_ID'], text: "#{key}: #{env[key]}")
      end
    end

    render status: :internal_server_error
  end
end
