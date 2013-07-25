class My::ProgressController < ApplicationController

  before_filter :find_student

  def index
    authorize! :index, :myprogress
  end

  def discipline
    authorize! :show, :myprogress
    @discipline = @disciplines.find(params[:id])
    @checkpoints = @discipline.checkpoints.order(:checkpoint_date)
  end

  def subject
    authorize! :show, :progress
    @subject = @subjects.find(params[:id])
    @subj = []
    @subjects.where(year: @subject.year, semester: @subject.semester)
              .sort_by{ |s| [s[:kind]]}.each do |s|
      mark = @student.marks.by_subject(s).first
      @subj << {title: s.title, type: s.type, test: mark.test,
                itog: mark.itog, strip: mark.strip, retake: mark.retake}
    end
    @subj = @subj.uniq()
  end

  private

  def find_student
    @student = Student.find(params[:student_id])
    @disciplines = Study::Discipline.now.from_student(@student)
    @subjects = @student.subjects
  end

end