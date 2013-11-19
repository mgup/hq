class Study::ExamsController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource through: :discipline

  def index ; end

  def new ; end

  def edit ; end

  def show ; end

  def update ; end

  def destroy ; end

  def resource_params
    params.fetch(:study_exam, {}).permit( :id, marks_attributes: [:id, :mark_student_group, :mark_value]
    )
  end

  private

  def load_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
  end
end