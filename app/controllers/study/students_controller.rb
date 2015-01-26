class Study::StudentsController < ApplicationController
  # load_resource :group
  load_resource :student
  skip_before_filter :authenticate_user! , only: [:show, :discipline]
  before_filter :year_term_params_and_group

  def show
    authorize! :show, :student_progress
    dates = []
    @rows = []

    @student.checkpoints_by_term(@year, @term).each do |checkpoint|
       dates << checkpoint.date
    end
    dates.uniq!
    dates.sort.each do |date|
      row = []
      row << date
      @student.disciplines_by_term(@year, @term).each do |discipline|
        marks = []
        marks << discipline
        Study::Checkpoint.by_discipline(discipline).by_date(date).each do |checkpoint|
          marks << {mark: checkpoint.marks.by_student(@student).last,
                    checkpoint: checkpoint}
        end
        row << marks
      end

      @rows << row
    end
  end

  def discipline
    authorize! :show, :student_discipline_progress
    @discipline = Study::Discipline.find params[:discipline]

    @checkpoints = @discipline.classes.order(:checkpoint_date)
  end

  private

  def year_term_params_and_group
    params[:year] ||= Study::Discipline::CURRENT_STUDY_YEAR
    params[:term] ||= Study::Discipline::CURRENT_STUDY_TERM
    @year = params[:year].to_i
    @term = params[:term].to_i
    @group = @student.group_at_date(Date.new((@term == 1 ? @year : @year+1), (@term == 1 ? 9 : 4), 15))
  end

  def student_params
    params.require(:students)
  end
end