# Контроллер для вывода страниц с сообщениями об ошибках.
class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def error404
    render status: :not_found
  end

  def error500
    @exception = env['action_dispatch.exception']

    text = "#{@exception.to_s}\n"
    text += "#{env['REQUEST_METHOD']}: http://#{env['HTTP_HOST']}#{env['REQUEST_URI']}#{"?#{env['QUERY_STRING']}" if env['QUERY_STRING'].size > 1}\n"
    text += params.inspect
    text += "\n"
    text += @exception.backtrace[0..4].join("\n")
    text += "\n....." if @exception.backtrace.size > 5
    if signed_in?
      text += "\n\n#{current_user.id}, #{current_user.full_name} (#{current_user.phone}, #{current_user.email})"
    end

    require 'telegram/bot'
    Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_TOKEN']) do |bot|
      bot.api.sendMessage(chat_id: ENV['TELEGRAM_CHAT_ID'], text: text)
    end

    # File.new(Rails.root.join('app', 'assets', 'images', 'stickers', 'sticker_175980787395461189.webp'))

    render status: :internal_server_error
  end
end
