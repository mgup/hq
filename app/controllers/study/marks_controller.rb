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
    @mark.update(mark: params[:mark])
    if @mark.checkpoint.is_checkpoint?
      render({ json: {id: @mark.id, result: "#{@mark.mark} из #{@mark.checkpoint.max}",
                      color:  (@mark.mark < @mark.checkpoint.min ? 'danger' : 'success')}
             })
    else
      render({ json: {id: @mark.id, result: @mark.result[:mark], color:  @mark.result[:color]}
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
    @students = @discipline.group.students.valid_for_today
  end

  #def find_chekpoint
  #  @checkpoint = Study::Checkpoint.find(params[:checkpoint_id])
  #  @discipline = Study::Discipline.find(params[:discipline_id])
  #  @students = Student.where(student_group_group: @checkpoint.discipline.group)
  #end
end