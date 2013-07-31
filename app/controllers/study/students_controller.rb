class Study::StudentsController < ApplicationController
  load_and_authorize_resource

  def show
    dates = []
    @rows = []
    @student.checkpoints.each do |checkpoint|
       dates << checkpoint.date
    end
    dates.uniq!
    dates.each do |date|
      row = []
      row << date
      @student.disciplines.each do |discipline|
        marks = []
        marks << discipline
        Study::Checkpoint.by_discipline(discipline).by_date(date).each do |checkpoint|
          marks << {mark: checkpoint.checkpointmarks.by_student(@student).last,
                    checkpoint: checkpoint}
        end
        row << marks
      end

      @rows << row
    end
  end

  def discipline
    @student = Student. find params[:id]
    @discipline = Study::Discipline.find params[:discipline]
    @checkpoints = @discipline.checkpoints.order(:checkpoint_date)
  end

  private

  def student_params
    params.require(:students)
  end
end