class Study::CheckpointsController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource through: :discipline, except: [:new, :create, :update]

  def index
    redirect_to new_study_discipline_checkpoint_path(@discipline) if @checkpoints.empty?
  end

  def new ; end

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
                                   name: study_checkpoint[:name], details: study_checkpoint[:details],
                                   max: study_checkpoint[:max], min: study_checkpoint[:min])
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
  end

  def resource_params
    params.fetch(:study_discipline, {}).permit(
        checkpoints_attributes: [:id, :checkpoint_date,
                                 :checkpoint_name, :checkpoint_details,
                                 :checkpoint_max, :checkpoint_min, :'_destroy']
    )
  end

  private

  def load_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
  end
end