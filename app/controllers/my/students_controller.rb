class My::StudentsController < ApplicationController
  # Это контроллер, в который должны заходить только студенты, поэтому
  # переключаем проверку авторизации с сотрудников на студентов.
  skip_before_filter :authenticate_user!
  before_filter :authenticate_student!

  # Проверка прав доступа и получение ресурсов должны производиться на основе
  # текущего пользователя, а не из параметров в адресной строке.
  before_filter :find_student, only: :show
  load_and_authorize_resource

  def show
    # @sessions = []
    # @student.subjects.each do |s|
    #   @sessions << {year: s.year, semester: s.semester, term: s.term}
    # end
    # @sessions = @sessions.uniq()
  end

  private

  # Ресурс, с которым будет работа, — это просто текущий авторизованный студент.
  def find_student
    @student = current_student
  end
end