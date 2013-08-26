class Study::DisciplinesController < ApplicationController
  load_and_authorize_resource

  def index
    #@disciplines = @disciplines.now
  end

  def new
    @teachers = nil
  end

  def edit
    @teachers = []
      if @discipline.teachers.count != 0
        @discipline.teachers.each do |teacher|
          @teachers << teacher.id if teacher != @discipline.teacher
         end
      end
  end

  def show ; end

  def update
    study_discipline = params[:study_discipline]
    study_discipline[:groups] = Group.find(params[:groups])
    discipline = Study::Discipline.find(params[:id])

    #Преподаватели
    if params[:teachers] != nil
      teachers = User.find(params[:teacher],params[:teachers])
      teachers.each do |t|
        if Study::DisciplineTeacher.where(subject_id: discipline.id, teacher_id: t.id) == []
          teacher = Study::DisciplineTeacher.new teacher: t.id, discipline: discipline.id
          teacher.save
        end
      end
      study_teachers = User.find(params[:teachers])
      discipline.teachers = study_teachers
    else
      x = discipline.teachers.without(discipline.subject_teacher)
      discipline.teachers.delete(x)
    end

    # Экзамен/зачёт
    exam = discipline.control
    exam.update_attributes(exam_type: params[:exam_type])

    #Курсовая работа и проект
    extra_exam(discipline, 'work')
    extra_exam(discipline, 'project')


    if discipline.update_attributes(group: study_discipline[:groups],
            semester: study_discipline[:semester], name: study_discipline[:name],
            year: study_discipline[:year], subject_teacher: params[:teacher])

      redirect_to study_disciplines_path, notice: 'Сохранено'
    else
      redirect_to edit_study_discipline_path(discipline), notice: 'Произошла ошибка'
    end
    
  end

  def create
    discipline = params[:study_discipline]
    @discipline = Study::Discipline.new year: discipline[:year], 
    semester: discipline[:semester], group: Group.find(params[:groups]),
        name: discipline[:name], subject_teacher: params[:teacher]

    if @discipline.save

      #Преподаватели
      if params[:teachers]
        params[:teachers].push(params[:teacher]).each do |t|
          teacher = Study::DisciplineTeacher.new teacher: t, discipline: @discipline.id
          teacher.save
        end
      end

      #Экзамен/зачёт
      control = Study::Exam.new discipline: @discipline, exam_type: params[:exam_type],
                              weight: params[:weight], exam_closed: false
      control.save

      #Курсовая работа и проект
      extra_exam(@discipline, 'work')
      extra_exam(@discipline, 'project')

      redirect_to study_disciplines_path, notice: 'Успешно создана.'
    else
      redirect_to new_study_discipline_path, notice: 'Произошла ошибка.'
    end
  end

  def resource_params
    params.fetch(:study_discipline, {}).permit( :year, :semester, :groups,
                                            :name, :subject_teacher)
  end

  private

  def extra_exam(discipline, type)
    if discipline.has?(type)
      if params["exam_term_#{type}"] == ''
        y = discipline.exams.where(exam_type: (type=='work' ? 2 : 3)).first
        Study::Exam.delete(y)
      end
    else
      if params["exam_term_#{type}"] != ''
        work =  Study::Exam.new discipline: discipline,
                                exam_type: (type=='work' ? 2 : 3), exam_closed: false
        work.save
      end
    end
  end

end