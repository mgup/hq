class Study::MarksController < ApplicationController
  before_filter :load_discipline
  load_and_authorize_resource :discipline
  load_and_authorize_resource :checkpoint, class: Study::Checkpoint
  load_and_authorize_resource through: :checkpoint

   #before_filter :find_chekpoint

  def index
    if @marks.empty?
      redirect_to new_study_discipline_checkpoint_mark_path(@discipline,
                                                            @checkpoint)
    end
  end

  def new ; end

  def edit ; end

  def show ; end

  def ajax_update
    @mark = Study::Mark.find(params[:id])
    @new = Study::Mark.create(@mark.attributes.merge(mark: params[:mark], id: nil,
                              created_at: DateTime.now, updated_at: DateTime.now, retake: true,
                              checkpoint_mark_submitted: DateTime.now))
    if @mark.checkpoint.is_checkpoint?
      render({ json: {id: @new.id, result: "#{@new.mark} из #{@new.checkpoint.max}",
                      color:  (@new.mark < @new.checkpoint.min ? 'danger' : 'success')}
             })
    else
      render({ json: {id: @new.id, result: @new.result[:mark], color:  @new.result[:color]}
             })
    end
  end

  def create
    #raise params.inspect
    marks = params[:marks]
    marks.each do |m|
      m[:student] = Student.find(m[:student])
      m[:checkpoint] = @checkpoint
      if m[:mark] != ''
        #if @checkpoint.checkpointmarks.by_student(m[:student]) == []
        mark=Study::Mark.new student: m[:student], checkpoint: m[:checkpoint],
                                         mark: m[:mark]
        mark.save!
        #elsif @checkpoint.checkpointmarks.by_student(m[:student]).first.mark != m[:mark]
        #  mark = @checkpoint.checkpointmarks.by_student(m[:student]).first
        #  mark.update_attributes(mark: m[:mark])
        #  end
      end
    end
    redirect_to study_discipline_checkpoint_marks_path(@discipline, @checkpoint), notice: 'Сохранено'
  end


  def resource_params
     params.fetch(:checkpointmark, {}).permit( :students, :mark, :checkpoint)
  end

  private

  def load_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
    @students = @discipline.students
  end
end