class Study::RepeatsController < ApplicationController
  load_and_authorize_resource :discipline, class: 'Study::Discipline'
  load_and_authorize_resource :exam, through: :discipline, class: 'Study::Exam'
  load_and_authorize_resource :repeat, through: :exam, class: 'Study::Repeat'

  def index
    render layout: 'modal'
  end

  def create
    if @repeat.save
      @repeats = @exam.repeats
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @repeat.destroy

    @repeats = @exam.repeats
    respond_to do |format|
      format.js
    end
  end

  def repeat
    respond_to do |format|
      format.pdf
    end
  end

  def resource_params
    params.fetch(:study_repeat, {}).permit(:exam_date, :exam_repeat, :exam_leader,  :exam_commission, :cafedra, student_ids: [],
                          commission_teachers_attributes: [:id, :user_id, :head, :science, :_destroy],
                          commission_head_attributes: [:id, :user_id, :head, :science, :_destroy],
                          )
  end
end
