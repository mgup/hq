class Study::DisciplinesController < ApplicationController
  before_filter :load_user_disciplines, only: :index
  before_filter :load_user_discipline,  only: [:show, :destroy]
  load_and_authorize_resource except: [:create]

  def index ; end

  def new
    # Создаём для дисциплины заготовку для итогового испытания
    # и 3-х дополнительных преподавателей.
    @discipline.exams.build
    3.times { @discipline.discipline_teachers.build }

    # Подгружаем коллег пользователя со всех кафедр, на которых он работает.
    # Их пользователь сможет выбрать в качестве ведущего преподавателя.
    # (Хотя может лучше сделать по-другому!?)
    detect_lead_teacher
    load_user_colleagues
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
    authorize! :create, Study::Discipline
    #raise resource_params.inspect
    @discipline = Study::Discipline.new(resource_params)
    #raise @discipline.inspect
    if @discipline.save
      # При необходимости, создаём записи о курсовой работе и курсовом проекте.
      @discipline.add_semester_work    if '1' == params[:has_semester_work]
      @discipline.add_semester_project if '1' == params[:has_semester_project]

      redirect_to study_disciplines_path, notice: 'Дисциплина успешно добавлена.'
    else
      # В случае ошибки необходимо вручную инициализировать поля для выбора
      # группы в том случае, если пользователь уже сделал свой выбор и ошибка
      # в каких-то других полях формы.
      #
      # Кроме того, нужно инициализировать массив с коллегами пользователя.
      if @discipline && @discipline.group
        @faculty = @discipline.group.speciality.faculty
        @speciality = @discipline.group.speciality
      end

      detect_lead_teacher
      load_user_colleagues

      render action: :new
    end
    #discipline = params[:study_discipline]
    #@discipline = Study::Discipline.new year: discipline[:year],
    #semester: discipline[:semester], group: Group.find(params[:groups]),
    #    name: discipline[:name], subject_teacher: params[:teacher]
    #
    #if @discipline.save
    #
    #  #Преподаватели
    #  if params[:teachers]
    #    params[:teachers].push(params[:teacher]).each do |t|
    #      teacher = Study::DisciplineTeacher.new teacher: t, discipline: @discipline.id
    #      teacher.save
    #    end
    #  end
    #
    #  #Экзамен/зачёт
    #  control = Study::Exam.new discipline: @discipline, exam_type: params[:exam_type],
    #                          weight: params[:weight], exam_closed: false
    #  control.save
    #
    #  #Курсовая работа и проект
    #  extra_exam(@discipline, 'work')
    #  extra_exam(@discipline, 'project')
    #
    #  redirect_to study_disciplines_path, notice: 'Успешно создана.'
    #else
    #  redirect_to new_study_discipline_path, notice: 'Произошла ошибка.'
    #end
  end

  def destroy
    @discipline.destroy

    redirect_to study_disciplines_path
  end

  def resource_params
    params.fetch(:study_discipline, {}).permit(
        :year, :semester, :group, :subject_group, :name, :subject_teacher,
        exams_attributes: [:exam_type, :exam_weight],
        discipline_teachers_attributes: [:teacher_id]
    )
  end

  private

  def load_user_discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:id])
  end

  def load_user_disciplines
    @disciplines = Study::Discipline.include_teacher(current_user)
  end

  def detect_lead_teacher
    @lead_teacher = current_user unless @discipline
    if @discipline.lead_teacher
      @lead_teacher = @discipline.lead_teacher
    else
      @lead_teacher = current_user
    end
  end

  def load_user_colleagues
    @teachers = []
    current_user.departments.academic.each do |d|
      @teachers = @teachers.concat(d.users.to_a)
    end
  end

  #def extra_exam(discipline, type)
  #  if discipline.has?(type)
  #    if params["exam_term_#{type}"] == ''
  #      y = discipline.exams.where(exam_type: (type=='work' ? 2 : 3)).first
  #      Study::Exam.delete(y)
  #    end
  #  else
  #    if params["exam_term_#{type}"] != ''
  #      work =  Study::Exam.new discipline: discipline,
  #                              exam_type: (type=='work' ? 2 : 3), exam_closed: false
  #      work.save
  #    end
  #  end
  #end
end