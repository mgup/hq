class Study::RepeatsController < ApplicationController
  load_and_authorize_resource :discipline, class: 'Study::Discipline'
  load_and_authorize_resource :exam, through: :discipline, class: 'Study::Exam'
  load_and_authorize_resource :repeat, through: :exam, class: 'Study::Repeat'

  def index
    @repeats = @repeats.order(exam_date: :desc)

    render layout: 'modal', locals: { skip_save_button: true }
  end

  def create
    @repeat.save
  end

  def resource_params
    params.fetch(:study_repeat, {}).permit(:exam_date, :exam_type, student_ids: [])
  end
end