class Study::CheckpointsController < ApplicationController
  load_and_authorize_resource
   before_filter :find_discipline, :set_result

  def index
    @checkpoints = @checkpoints.by_discipline(@discipline).order(:checkpoint_date)
    if params[:id]
      @checkpoint = Study::Checkpoint.find(params[:id])
    else
      @checkpoint = Study::Checkpoint.new
    end
  end

  def new

  end

  def edit
    @checkpoints = @discipline.checkpoints.control
    @max_b = 0
    @min_b = 0
    @checkpoints.each do |c|
      @max_b += c.max.round
      @min_b += c.min.round
    end
    @error = (@max_b != @max or @min_b != @min) ? 'danger' : 'success'
  end

  def show
    if params[:study_checkpoint]
      study_checkpoint = params[:study_checkpoint]
      checkpoint = Study::Checkpoint.find(study_checkpoint[:id])
      checkpoint.update_attributes(checkpoint_type: study_checkpoint[:type],
                                   date: study_checkpoint[:date],
                                   name: study_checkpoint[:name], details: study_checkpoint[:details],)
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
  end

  def update
    if params[:checkpoints]
      checkpoints = params[:checkpoints]
      checkpoints.each do |check|
        checkpoint=Study::Checkpoint.find(check[:id])
        checkpoint.update_attributes(check)
      end
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Сохранено'
    end
  end

  def create
    checkpoint = params[:study_checkpoint]
    min = checkpoint[:type]=='3' ? 11 : nil
    max = checkpoint[:type]=='3' ? 20 : nil
    @checkpoint = Study::Checkpoint.new checkpoint_type: checkpoint[:type],
                          date: checkpoint[:date], discipline: @discipline,
                          name: checkpoint[:name], details: checkpoint[:details],
                          min: min, max: max
    if @checkpoint.save
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Успешно создано'
    else
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Произошла ошибка'
    end
  end

  def resource_params
    params.fetch(:study_checkpoint, {}).permit( :name, :checkpoint_type, :date,
                                            :details, :min, :max)
  end
  private

  def find_discipline
    @discipline = Study::Discipline.find(params[:discipline_id])
  end
  def set_result
    @max = 80
    @min = 44
  end
end