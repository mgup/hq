class Study::CheckpointsController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource through: :discipline, except: [:new, :create, :update, :destroy, :change_date, :update_date]

  def index
    redirect_to new_study_discipline_checkpoint_path(@discipline) if @checkpoints.empty?
    @classes = @discipline.classes
    @students = @discipline.students
  end

  def new ; end

  def create
    #raise params.inspect
    @checkpoint = Study::Checkpoint.new(resource_params)
    if @checkpoint.save
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
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
                                   name: study_checkpoint[:name], details: study_checkpoint[:details],
                                   max: study_checkpoint[:max], min: study_checkpoint[:min])
      redirect_to study_discipline_checkpoints_path(@discipline)
    else
      redirect_to study_discipline_checkpoints_path(@discipline)
    end
  end

  def update
    #raise resource_params.inspect
    @checkpoint = Study::Checkpoint.find(params[:id])
    if @checkpoint.update(resource_params)
      redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Изменения успешно сохранены.'
    else
      if resource_params.include?(:marks_attributes)
        #render template: 'study/marks/index'
        #return
        redirect_to study_discipline_checkpoint_marks_path(@discipline,
                                                              @checkpoint)
      else
        render action: :edit
      end
    end
  end

  def change_date
    load_discipline
    @checkpoint = Study::Checkpoint.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update_date
    @checkpoint = Study::Checkpoint.find(params[:id])
    @checkpoint.update checkpoint_date: params[:study_checkpoint][:date]
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @checkpoint = Study::Checkpoint.find(params[:id])
    @checkpoint.destroy

    redirect_to study_discipline_checkpoints_path(@discipline)
  end

  def resource_params
    params.fetch(:study_checkpoint, {}).permit( :id, :date, :checkpoint_name, :checkpoint_details, :checkpoint_subject, :checkpoint_type,
                                                :checkpoint_max, :checkpoint_min, :'_destroy',
                                                marks_attributes: [:id, :checkpoint_mark_student, :mark, :created_at, :updated_at]
    )
  end

  private

  def load_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
  end
end