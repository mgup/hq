class Study::RepeatsController < ApplicationController
  load_and_authorize_resource :discipline, class: 'Study::Discipline'
  load_and_authorize_resource :exam, through: :discipline, class: 'Study::Exam'
  load_and_authorize_resource :repeat, through: :exam, class: 'Study::Repeat'

  def index
    @repeats = @repeats.order(exam_date: :desc)

    render layout: 'modal', locals: { modal_sm: true, skip_save_button: true }
  end
end