class DashboardController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    # Если авторизовался студент — перенаправляем в личный кабинет студента.
    if student_signed_in?
      redirect_to my_student_path and return
    else

      redirect_to new_user_session_path and return unless user_signed_in?

      # redirect_to selection_contract_path if current_user.is?(:zamestitel_otvetstvennogo_sekretarja)

      # redirect_to selection_contract_path if current_user.is?(:chief_accountant)

      # redirect_to "#{root_url}ciot" if current_user.is?(:ciot)
      redirect_to students_path if current_user.is?(:student_hr)
    end
  end

  def test_exception
    fail 'Ошибка'
  end
end
