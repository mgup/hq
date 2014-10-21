class Study::DisciplinesController < ApplicationController
  before_filter :load_user_disciplines, only: :index
  before_filter :load_user_discipline,  only: [:edit, :destroy]
  load_and_authorize_resource except: [:create]

  def index

  end

  def new
    # Создаём для дисциплины заготовку для итогового испытания
    @discipline.build_final_exam

    # Подгружаем коллег пользователя со всех кафедр, на которых он работает.
    # Их пользователь сможет выбрать в качестве ведущего преподавателя.
    # (Хотя может лучше сделать по-другому!?)
    detect_lead_teacher
    load_user_colleagues
  end

  #def show ; end

  def create
    # raise params.inspect
    authorize! :create, Study::Discipline
    @discipline = Study::Discipline.new(resource_params)
    if @discipline.save
      respond_to do |format|
        format.js
        format.html do
          # При необходимости, создаём записи о курсовой работе и курсовом проекте.
          @discipline.add_semester_work    if '1' == params[:has_semester_work]
          @discipline.add_semester_project if '1' == params[:has_semester_project]

          if params[:plans] == '1'
            redirect_to study_plans_path(faculty: @discipline.group.speciality.faculty.id,
                                         speciality: @discipline.group.speciality.id,
                                         course: @discipline.group.course,
                                         form: @discipline.group.form,
                                         group: @discipline.group.id)
          else
            redirect_to study_disciplines_path, notice: 'Дисциплина успешно добавлена.'
          end
        end
      end
    else
      # raise @discipline.errors.inspect
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
  end

  def edit
    detect_lead_teacher
    load_user_colleagues
    @faculty = @discipline.group.speciality.faculty
    @speciality = @discipline.group.speciality
  end

  def manage
    authorize! :manage, :plans

    render layout: 'modal'
  end

  def update
    authorize! :update, Study::Discipline

    if @discipline.update(resource_params)
      respond_to do |format|
        format.js
        format.html do
          if params[:plan] == '1'
            # Идёт редактирование учебного плана.
            redirect_to study_plans_path(faculty: @discipline.group.speciality.faculty.id,
                                         speciality: @discipline.group.speciality.id,
                                         course: @discipline.group.course,
                                         form: @discipline.group.form,
                                         group: @discipline.group.id)
          else
            @discipline.add_semester_work    if ('1' == params[:has_semester_work] and !@discipline.semester_work)
            @discipline.add_semester_project if ('1' == params[:has_semester_project] and !@discipline.semester_project)

            @discipline.destroy_semester_work    if ('1' != params[:has_semester_work] and @discipline.semester_work)
            @discipline.destroy_semester_project if ('1' != params[:has_semester_project] and @discipline.semester_project)

            if Study::Discipline.with_brs.include_teacher(current_user).include? @discipline
              redirect_to study_discipline_checkpoints_path(@discipline), notice: 'Изменения успешно сохранены.'
            else
              redirect_to study_disciplines_path, notice: 'Изменения успешно сохранены.'
            end
          end
        end
      end
    else
      if resource_params.include?(:checkpoints_attributes)
        # Идёт редактирование контрольных точек — возвращаем туда.
        render template: 'study/checkpoints/new'
        return
      else
        detect_lead_teacher
        load_user_colleagues

        if @discipline && @discipline.group
          @faculty = @discipline.group.speciality.faculty
          @speciality = @discipline.group.speciality
        end

        render action: :edit
      end
    end
    #raise params.inspect
  end

  def destroy
    @discipline.destroy if @discipline.checkpoints.empty?

    redirect_to study_disciplines_path
  end

  def print_group
    authorize! :manage, Study::Discipline
    @discipline = Study::Discipline.include_teacher(current_user).find(params[:discipline_id])
    @students = @discipline.students
    respond_to do |format|
      format.pdf
    end
  end


  def resource_params
    params.fetch(:study_discipline, {}).permit(
        :subject_year, :subject_brs, :subject_semester, :group, :subject_group, :subject_name,
        :subject_teacher, :department_id,
        final_exam_attributes: [:id, :exam_type, :exam_weight],
        discipline_teachers_attributes: [:id, :teacher_id, :'_destroy'],
        lectures_attributes: [:id, :checkpoint_date, :'_destroy'],
        seminars_attributes: [:id, :checkpoint_date, :'_destroy'],
        checkpoints_attributes: [:id, :checkpoint_date,
                                 :checkpoint_name, :checkpoint_details,
                                 :checkpoint_max, :checkpoint_min, :'_destroy'],
        additional_exams_attributes: [:id, :exam_type, :'_destroy']
    )
  end

  def print_disciplines
    authorize! :index, :disciplines
    @disciplines = ActiveRecord::Base.connection.execute("
    SELECT department_sname AS `Кафедра`, CONCAT_WS('-', group_name, group_course, group_number) AS `Группа`,
       subject_name AS `Дисциплина`, CASE WHEN user_name IS NULL or user_name = '' THEN CONCAT_WS(' ',
                        (SELECT dictionary.dictionary_ip FROM dictionary JOIN user ON user.user_fname = dictionary.dictionary_id LIMIT 1),
                        (SELECT dictionary.dictionary_ip FROM dictionary JOIN user ON user.user_iname = dictionary.dictionary_id LIMIT 1),
                        (SELECT dictionary.dictionary_ip FROM dictionary JOIN user ON user.user_oname = dictionary.dictionary_id LIMIT 1))
                        ELSE user_name END AS `Преподаватель`, COUNT(checkpoint_id) AS `Занятий`,
    (SELECT COUNT(*) FROM checkpoint WHERE checkpoint_subject = subject_id AND checkpoint_date < '#{Date.today.strftime('%Y-%m-%d')}') AS `Прошло занятий`,
    (SELECT COUNT(*) FROM checkpoint WHERE checkpoint_subject = subject_id AND checkpoint_date < '#{Date.today.strftime('%Y-%m-%d')}' AND (SELECT COUNT(*) FROM checkpoint_mark WHERE checkpoint_mark_checkpoint = checkpoint_id > 0) AND (SELECT COUNT(DISTINCT checkpoint_mark_student) FROM checkpoint_mark WHERE checkpoint_mark_checkpoint = checkpoint_id) >= (SELECT COUNT(*) FROM student_group WHERE student_group_group = group_id AND student_group_status = '101')) AS `Оценки`
    FROM subject JOIN user ON user_id = subject_teacher JOIN
    department ON department.department_id = user.user_department JOIN `group` ON group_id = subject_group JOIN checkpoint ON checkpoint_subject =
    subject_id WHERE subject_year = #{Study::Discipline::CURRENT_STUDY_YEAR} AND subject_semester = #{Study::Discipline::CURRENT_STUDY_TERM} GROUP BY
    subject_id ORDER BY department_sname ASC, group_course ASC, group_name ASC, group_number ASC, subject_name ASC;
")
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="' + "Заполнение БРС на #{Date.today.strftime('%d.%m.%Y')}.xlsx" + '"'
      }
    end
  end

  private

  def load_user_discipline
    if can?(:manage, :plans)
      @discipline = Study::Discipline.find(params[:id])
    else
      @discipline = Study::Discipline.include_teacher(current_user).find(params[:id])
    end
  end

  def load_user_disciplines
    @disciplines = Study::Discipline.with_brs.include_teacher(current_user).order('subject_semester DESC', :subject_name, :subject_group)
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
end
