class GraduateStudentsController < ApplicationController
  load_and_authorize_resource

  def create
    graduate = Graduate.find(params[:graduate_id])

    student = graduate.graduate_students.build
    student.student_id = params[:student_id]

    if student.save
      redirect_to edit_graduate_graduate_student_path(graduate, student), notice: 'Информация о студенте создана.'
    else
      redirect_to students_graduate_path(graduate)
    end
  end

  def edit
    @graduate = @graduate_student.graduate
  end

  def resource_params
    params.fetch(:graduate_student, {}).permit()
  end
end