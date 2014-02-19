class Study::StudentsController < ApplicationController

  load_resource
  skip_before_filter :authenticate_user! , only: [:show, :discipline]

  def show
    authorize! :show, :student_progress
    dates = []
    @rows = []
    @student.checkpoints.each do |checkpoint|
       dates << checkpoint.date
    end
    dates.uniq!
    dates.sort.each do |date|
      row = []
      row << date
      @student.disciplines.each do |discipline|
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
    @student = Student. find params[:id]
    @discipline = Study::Discipline.find params[:discipline]
    @checkpoints = @discipline.classes.order(:checkpoint_date)
  end

  private

  def student_params
    params.require(:students)
  end
end