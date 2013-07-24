class Study::CheckpointmarksController < ApplicationController
  load_and_authorize_resource

   before_filter :find_chekpoint

  def index
    @checkpointmarks = @checkpointmarks.by_checkpoint(@checkpoint)
  end

  def new ; end

  def edit ; end

  def show ; end

  def update ; end

  def create
    marks = params[:checkpointmarks]
    marks.each do |m|
      m[:students] = Student.find(m[:students])
      m[:checkpoint] = @checkpoint
      if m[:mark] != ''
        if @checkpoint.checkpointmarks.where(student: m[:students]) == []
          mark=Study::Checkpointmark.new students: m[:students], checkpoint: m[:checkpoint],
                                         mark: m[:mark]
          mark.save!
        elsif @checkpoint.checkpointmarks.where(student: m[:students]).first.mark != m[:mark]
          mark = @checkpoint.checkpointmarks.where(student: m[:students]).first
          mark.update_attributes(mark: m[:mark])
          end
      end
    end
    redirect_to study_discipline_checkpoint_checkpointmarks_path(@discipline, @checkpoint), notice: 'Сохранено'
  end


  def resource_params
     params.fetch(:checkpointmark, {}).permit( :students, :mark, :checkpoint)
  end
  private

  def find_chekpoint
    @checkpoint = Study::Checkpoint.find(params[:checkpoint_id])
    @discipline = Study::Discipline.find(params[:discipline_id])
    @students = Student.where(group: @checkpoint.discipline.group)
  end
end