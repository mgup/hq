# Контроллер для вывода страниц с сообщениями об ошибках.
class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def error404
    render status: :not_found
  end

  def error500
    render status: :internal_server_error
  end
end
