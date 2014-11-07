# Контроллер для работы с учебными группами.
class GroupsController < ApplicationController
  load_and_authorize_resource

  # Параметры по-умолчанию для списка групп.
  before_action :initialize_filters_defaults, only: [:index]

  # Просмотр списка групп и студентов в них.
  def index

  end

  # Просмотр списка студентов в группе.
  def show
    respond_to do |format|
      format.pdf
    end
  end
end
