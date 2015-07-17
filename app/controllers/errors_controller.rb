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
      bot.api.sendMessage(chat_id: ENV['TELEGRAM_CHAT_ID'], text: text)
    end

    render status: :internal_server_error
  end
end
