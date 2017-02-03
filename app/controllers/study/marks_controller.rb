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


  def add_package
    file_data = params[:marks_add]

    if file_data
      added = 0
      r = Roo::Spreadsheet.open(file_data.tempfile.path)
      r.each_with_pagename do |_, sheet|
        (1..sheet.last_row).each do |row|
          last_name  = sheet.cell(row,'A')
          first_name = sheet.cell(row,'B')
          # if sheet.cell(row,'C').to_i
            result     = sheet.cell(row,'C').to_i
          # else
          #   patronym   = sheet.cell(row,'C')
          #   result     = sheet.cell(row,'D').to_i
          # end
          # student = @discipline.group.students.my_filter(name: "#{last_name} #{first_name} #{patronym}").first
          student = @discipline.group.students.my_filter(name: "#{last_name} #{first_name}").first
          if student && sheet.cell(row,'D') && result >= 0 && result <= @checkpoint.max
            retake = Study::Mark.by_checkpoint(@checkpoint).by_student(student).length > 0
            mark = Study::Mark.create student: student, checkpoint: @checkpoint,
                                 mark: result, checkpoint_mark_submitted: Time.now,
                                 checkpoint_mark_retake: retake
            added += 1 if mark.save
          end
        end
      end
      redirect_to study_discipline_checkpoint_marks_path(@discipline, @checkpoint),
                  notice: "Обработка файла завершена. Внесено #{added} #{Russian::pluralize(added, 'оценка', 'оценки', 'оценок')}."
    else
      redirect_to study_discipline_checkpoint_marks_path(@discipline, @checkpoint), notice: 'Произошла ошибка'
    end
  end

  private

  def load_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
    @students = @discipline.students
  end
end
