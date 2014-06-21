class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    cannot :manage, Achievement
    cannot :manage, Rating

    #can :manage, Student
    #can :manage, :student
    if user.is_a?(Student)
      # Набор разрешений для студентов.
      can :manage, Student, student_group_id: user.id
    else
      #if user.is?(:typer)
      #  can [:create, :read], [Study::Subject, Study::Mark], user_id: user.id
      #  can :update, Study::Mark, user_id: user.id
      #end
      #
      #if user.is?(:supertyper)
      #  can :manage, [Study::Subject, Study::Mark]
      #end

      # Так как у преподавателей самые "узкие" роли с разными ограничениями —
      # выносим их в начало.
      # TODO В будущем нужно сделать иерархию ролей в базе, чтобы порядок их обработки устанавливался автоматически.
      if user.is?(:lecturer)
        lecturer(user)
      end
      if user.is?(:subdepartment)
        subdepartment(user)
      end
      if user.is?(:subdepartment_assistant)
        subdepartment_assistant(user)
      end

      user.roles.reject { |r| ['lecturer', 'subdepartment'].include?(r.name) }.each do |role|
        send(role.name, user) if respond_to?(role.name)
      end

      can :manage, User, user_id: user.id

      if user.is?(:zamestitel_otvetstvennogo_sekretarja)
        can :index, :selection_contracts
      end

      if user.is?(:chief_accountant)
        can :index, :selection_contracts
      end

      #if user.is?(:lecturer)
        # can :manage, Study::Exam
        # can :manage, Study::ExamMark
        # Загрузка ресурсов, принадлежащих только текущему пользователю,
        # производится в Study::DisciplinesController.
        # can :manage, [Study::Discipline], Study::Discipline.include_teacher(user) { |d| }
      #end

      if user.is?(:developer)
        can :manage, :all
      end

      if user.is?(:ciot)
        can :manage, :ciot
      end

      if user.is?(:library)
        can :manage, :library
      end

      if user.is?(:student_hr) || user.is?(:student_hr_boss)
        can :manage, Student
        can :manage, Office::Order
        can :manage, :student
        can :index, :groups

        can :reference, Student.valid_for_today
      end

    end

    can [:index, :show], :progress
    can :show, [:student_progress, :student_discipline_progress]
    can :manage, :progress_group

    can [:index, :new, :create, :options, :download_pdf], My::Support

    can :manage, EventDate
    can :actual, :events
    can :create, EventDateClaim

    can :applications, Entrance::Campaign
  end

  # Обычный преподаватель.
  def lecturer(user)
    can :manage, Study::Discipline
    can :manage, Study::Checkpoint
    can :manage, Study::Mark
    can :manage, Study::Exam
    # can :manage, [Achievement, AchievementReport], user_id: user.id

    # cannot :validate, Achievement
    # cannot :validate_social, Achievement
    # cannot :validate_selection, Achievement
    # cannot :validate_additional, Achievement

    can :index, Rating, user_id: user.id
  end

  def subdepartment_assistant(user)
    lecturer(user)
  end

  # Заведующий кафедрой.
  def subdepartment(user)
    lecturer(user)

    # can :validate, Achievement
  end

  # Проректор по научно-исследовательской работе
  def pro_rector_science(user)
    #can :update, Achievement
    #can :validate, Achievement
  end

  def executive_secretary(user)
    # can :update, Achievement
    # can :validate_selection, Achievement
  end

  def dean(user)
    can :manage, Achievement
    # can :update, Achievement
    can :validate_additional, Achievement
  end

  def pro_rector_social(user)
    can :update, Achievement
    can :manage, My::Support
    # can :update, Achievement
    # can :validate_social, Achievement
    can :manage, Event, event_category_id: EventCategory::SOCIAL_EVENTS_CATEGORY
    can :manage, EventDateClaim
    cannot :manage, Event, event_category_id: EventCategory::MEDICAL_EXAMINATION_CATEGORY
    can :manage, Curator::TaskUser
    can :manage, Curator::Task
    can :manage, Curator::TaskType
    can :manage, Hostel::Offense
    can :manage, Hostel::Report
  end

  def curator(user)
    can :actual, :curator_tasks
    can :manage, Curator::TaskUser, user_id: user.id
    can :manage, Hostel::Report
  end

  def soc_support_boss(user)
    soc_support(user)
    soc_support_vedush(user)
  end

  def soc_support_vedush(user)
    cannot :manage, Event, event_category_id: EventCategory::SOCIAL_EVENTS_CATEGORY
    can :without_med, User
    can :manage, Event, event_category_id: EventCategory::MEDICAL_EXAMINATION_CATEGORY
  end

  def soc_support(user)
    can :manage, My::Support
  end

  def faculty_employee(user)
    # Выпускников пока закрываем
    #can :manage, Graduate
    #can :manage, GraduateStudent
    #can :manage, GraduateSubject
    #can :manage, GraduateMark

    can :manage, :plans

    # Подумать, как совместить это с тем, что Дирекция не преподаватель!!!
    can :manage, Study::Discipline
    can :manage, Study::Exam
    can :manage, Study::Repeat
  end

  def selection(user)
    can :manage, Entrance::Campaign
    can :manage, Entrance::Entrant
    can :manage, Entrance::ExamResult
    can :manage, Entrance::Application
  end
end
