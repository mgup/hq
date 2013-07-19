class Study::DisciplinesController < ApplicationController
  load_and_authorize_resource

  def index
    @disciplines = @disciplines.where(subject_year: 2013)
  end

  def new
    @teachers = nil
  end

  def edit
    @teachers = []
      if @discipline.teachers.count != 0
        @discipline.teachers.each do |teacher|
          @teachers << teacher.id
         end
         @teachers.shift
      end
  end

  def show ; end

  def update
    study_discipline = params[:study_discipline]
    study_discipline[:group] = Group.find(params[:group])
    discipline = Study::Discipline.find(params[:id])

    #Преподаватели
    if params[:teachers] != nil
      teachers = User.find(params[:teachers])
      teachers.each do |t|
        if Study::DisciplineTeacher.where(subject_id: discipline.id, teacher_id: t.id) == []
          extra = Study::DisciplineTeacher.new teacher: t.id, discipline: discipline.id
          extra.save
        end
      end
    study_teachers = User.find(params[:teachers])
    discipline.teachers = study_teachers
    else
      x = discipline.teachers
      discipline.teachers.delete(x)
    end
    if params[:teacher]
      teacher = User.find(params[:teacher])
      if Study::DisciplineTeacher.where(subject_id: discipline.id, teacher_id: teacher.id) == []
        main = Study::DisciplineTeacher.new teacher: teacher.id, discipline: discipline.id
        main.save
      end
    end

    # Экзамен/зачёт
    exam = discipline.control
    exam.update_attributes(exam_type: params[:exam_type])

    #Курсовая работа и проект
    if !discipline.has_work?
      if params[:exam_term_work] != ''
        work =  Study::Exam.new discipline: discipline,
                                exam_type: 2, exam_closed: false
        work.save
      end
    else
      if params[:exam_term_work] == ''
        y =  discipline.exams.where(exam_type: 2).first
        Study::Exam.delete(y)
      end
    end
    if !discipline.has_project?
      if params[:exam_term_project] != ''
        work =  Study::Exam.new discipline: discipline,
                                exam_type: 3, exam_closed: false
        work.save
      end
    else
      if params[:exam_term_project] == ''
        y =  discipline.exams.where(exam_type: 3).first
        Study::Exam.delete(y)
      end
    end

    if discipline.update_attributes(group: study_discipline[:group],
    semester: study_discipline[:semester], name: study_discipline[:name],
    year: study_discipline[:year])

      redirect_to study_disciplines_path, notice: 'Сохранено'
    else
      redirect_to edit_study_discipline_path(discipline), notice: 'Произошла ошибка'
    end
    
  end

  def create
    discipline = params[:study_discipline]
    @discipline = Study::Discipline.new year: discipline[:year], 
    semester: discipline[:semester], group: Group.find(params[:group]),
        name: discipline[:name]
    if @discipline.save

      #Преподаватели
      if params[:teachers]
        params[:teachers].each do |t|
          teach = Study::DisciplineTeacher.new teacher: t, discipline: @discipline.id
          teach.save
        end
      end
      teacher = Study::DisciplineTeacher.new teacher: params[:teacher], discipline: @discipline.id
      teacher.save

      #Экзамен/зачёт
      control = Study::Exam.new discipline: @discipline,
                                exam_type: params[:exam_type], weight: params[:weight],
                                exam_closed: false
      control.save

      #Курсовая работа и проект
      if params[:exam_term_work] != ''
        work =  Study::Exam.new discipline: @discipline,
                                exam_type: 2, exam_closed: false
        work.save
      end
      if params[:exam_term_project] != ''
        project =  Study::Exam.new discipline: @discipline,
                                exam_type: 3, exam_closed: false
        project.save
      end

      redirect_to study_disciplines_path, notice: 'Успешно создана.'
    else
      redirect_to new_study_discipline_path
    end
  end

  def resource_params
    params.fetch(:study_discipline, {}).permit( :year, :semester, :group,
                                            :name, :subject_teacher)
  end
end