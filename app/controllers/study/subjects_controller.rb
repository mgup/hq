class Study::SubjectsController < ApplicationController
  load_and_authorize_resource

  def index ; end

  def new ; end

  def show ; end

  def update ; end

  def create
    study_subject=params[:study_subject]
    subject = Study::Subject.where(year: study_subject[:year]).where(semester: study_subject[:semester]).where(group_id: study_subject[:group_id]).where(title: study_subject[:title]).where(kind: study_subject[:kind]).where(user_id: study_subject[:user_id]).first
    if subject
      redirect_to study_subject_marks_path(subject)
    else
      @subject = Study::Subject.new(year: study_subject[:year], semester: study_subject[:semester], group_id: study_subject[:group_id], title: study_subject[:title], kind: study_subject[:kind], user_id: study_subject[:user_id])
      @subject.save
      if @subject.save
        redirect_to study_subject_marks_path(@subject), notice: 'Успешно создана.'
      else
        redirect_to new_study_subject_path
      end
    end
  end

  def resource_params
    params.fetch(:study_subject, {}).permit(:user_id, :year, :semester, :group_id,
                                            :title, :kind)
  end
end