class My::ProgressController < ApplicationController

  before_filter :find_student
  skip_before_filter :authenticate_user!
  before_filter :authenticate_student!

  def index
    authorize! :manage, :student
  end

  def discipline
    authorize! :manage, :student
    @discipline = @disciplines.find(params[:id])
    @checkpoints = @discipline.checkpoints.order(:checkpoint_date)
  end

  def subject
    authorize! :manage, :student
    @subject = @subjects.find(params[:id])
    @subj = []
    @subjects.where(year: @subject.year, semester: @subject.semester)
              .sort_by{ |s| [s[:kind]]}.each do |s|
      mark = @student.xmarks.by_subject(s).first
      @subj << {title: s.title, type: s.type, test: mark.test[:mark],
                itog: mark.test[:itog], strip: mark.test[:strip], retake: mark.retake}
    end
    @subj = @subj.uniq()
  end

  private

  def find_student
    @student = current_student
    @disciplines = Study::Discipline.now.from_student(@student)
    @subjects = @student.subjects
  end

end