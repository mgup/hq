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

      # if user.is?(:zamestitel_otvetstvennogo_sekretarja)
      #   # can :index, :selection_contracts
      # end

      # if user.is?(:chief_accountant)
      #   can :index, :selection_contracts
      # end

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
        can :work, :all_faculties
      end

      if user.is?(:firefighter)
        can :rebukes, Office::Order
        can :show,  Office::Order
      end

      if user.is?(:student_hr) || user.is?(:student_hr_boss)
        can :manage, Student
        can :manage, Document::Doc
        can :manage, Office::Order
        can :manage, :student
        can :index, :groups
        can :manage, Group

        can :reference, Student.valid_for_today
        can :soccard_mistakes, Student

        can :work, :all_faculties
      end

      # отдел рецензирования
      if user.is?(:recenz)
        can :manage, Review
        can :manage, University
      end

      # закупки
      if user.is?(:purchase_manager) || user.is?(:purchase_user) || user.is?(:ciot)
        can :manage, Purchase::Good
        can :manage, Purchase::Supplier
        can :manage, Purchase::LineItem
        can :manage, Purchase::Purchase
      end
    end

    can [:index, :show], :progress
    can :show, [:student_progress, :student_discipline_progress]
    can :manage, :progress_group

    can [:index, :new, :create, :options, :download_pdf], My::Support

    can :manage, EventDate
    can :actual, :events
    can :create, EventDateClaim
    can :index, Entrance::Date
    can :index, Entrance::MinScore

    can :applications, Entrance::Campaign
    can [:balls, :rating, :print_all, :crimea_rating, :print_direction_register], Entrance::Campaign
    can :show, Entrance::Event

    can :index, EducationPrice
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
    can :manage, Curator::TaskUser
    can :manage, Curator::Task
    can :manage, Curator::TaskType
    can :manage, Hostel::Offense
    can :manage, Hostel::Report
    soc_support_event(user)
    can :soccard_mistakes, Student
    can :delete, Social::Document

  end

  def soc_support_event(user)
    can :manage, Event, event_category_id: EventCategory::SOCIAL_EVENTS_CATEGORY
    can :manage, EventDateClaim
  end

  def soc_support_vedush(user)
    cannot :manage, Event, event_category_id: EventCategory::SOCIAL_EVENTS_CATEGORY
    can :without_med, User
    can :manage, Event, event_category_id: EventCategory::MEDICAL_EXAMINATION_CATEGORY
    can :manage, Social::Document
    cannot :delete, Social::Document
    can :manage, Social::DocumentType
    can :read, Student
    can :study, Student

    can :manage, Office::Order, order_template: Office::Order::REPRIMAND_TEMPLATE
    cannot :sign, Office::Order
    can :work, :all_faculties
  end

  def soc_support(user)
    can :manage, My::Support
    can :manage, Social::Document
    cannot :delete, Social::Document
    can :manage, Social::DocumentType
    can :read, Student
    can :study, Student

    can :manage, Office::Order, order_template: Office::Order::REPRIMAND_TEMPLATE
    can :work, :all_faculties
  end

  def faculty_employee(user)
    can :manage, :plans
    can :create_employer, Person
    can :manage, Proof

    # Подумать, как совместить это с тем, что Дирекция не преподаватель!!!
    can :manage, Study::Discipline
    can :manage, Study::Exam
    can :manage, Study::Repeat
    can :manage, Office::Order
    cannot :sign, Office::Order
    can :manage, Group
    can :index, :groups

    can :manage, Student
    can :manage, Person
  end

  def aspirantura(user)
    can :manage, :plans

    # Подумать, как совместить это с тем, что Дирекция не преподаватель!!!
    can :manage, Study::Discipline
    can :manage, Study::Exam
    can :manage, Study::Repeat
    can :manage, Office::Order
    cannot :sign, Office::Order
    can :manage, Group
    can :index, :groups

    can :work, :all_faculties
    can :manage, Student, student_group_id: Student.aspirants.collect{|s| s.id}
    can :create, Student
    can :manage, Person
  end

  def ioo(user)
    faculty_employee(user)

    can :work, :all_faculties
  end

  def selection(user)
    can :manage, Entrance::Campaign
    cannot :orders, Entrance::Campaign
    can :manage, Entrance::Entrant
    cannot :edit, Entrance::Entrant
    cannot :destroy, Entrance::Entrant

    can :manage, Entrance::ExamResult
    can :manage, Entrance::Application
    can :manage, Entrance::DocumentMovement
    can :manage, Entrance::EventEntrant
    can :manage, Entrance::Contract
    can :statistics, Entrance::Contract
  end

  def selection_technical_secretary(user)
    can :manage, Entrance::Campaign
    cannot :orders, Entrance::Campaign
    can :manage,      Entrance::Entrant
    cannot :destroy,  Entrance::Entrant

    can :manage, Entrance::ExamResult
    can :manage, Entrance::Application
    can :manage, Entrance::EventEntrant
    can :manage, Entrance::DocumentMovement
    can :manage, Entrance::Contract
    can :statistics, Entrance::Contract
    can :manage, Entrance::UseCheck
    can :manage, Entrance::UseCheckResult
    can :manage, Entrance::Achievement
  end

  def selection_editor(user)
    can :manage, Entrance::Campaign
    cannot :orders, Entrance::Campaign
    can :manage, Entrance::Entrant
    can :manage, Entrance::ExamResult
    can :manage, Entrance::Application
    can :manage, Entrance::EventEntrant
    can :manage, Entrance::DocumentMovement
    can :manage, Entrance::Contract
    can :statistics, Entrance::Contract
    can :manage, Entrance::UseCheck
    can :manage, Entrance::UseCheckResult

    can :reject, :entrance_applications
    can :create, :entrance_orders
    can :manage, Entrance::Achievement
  end

  def selection_io(user)
    can :manage, Entrance::Campaign
    cannot :orders, Entrance::Campaign
    can :manage,      Entrance::Entrant, ioo: true
    cannot :destroy,  Entrance::Entrant
    can :manage, Entrance::ExamResult
    can :manage, Entrance::Application
    can :manage, Entrance::EventEntrant
    can :manage, Entrance::DocumentMovement
    can :manage, Entrance::Contract
    can :statistics, Entrance::Contract
    can :manage, Entrance::UseCheck
    can :manage, Entrance::UseCheckResult
  end

  def selection_foreign(user)
    can :manage, Entrance::Campaign
    cannot :orders, Entrance::Campaign

    # can :manage, Entrance::Entrant, identity_document_type_id: 3
    # can :manage, Entrance::Entrant, campaign_id: Entrance::Campaign::STATELINE
    can :manage, Entrance::Entrant
    cannot :destroy,  Entrance::Entrant
    can :manage, Entrance::ExamResult
    can :manage, Entrance::Application
    can :manage, Entrance::EventEntrant
    can :manage, Entrance::DocumentMovement
    can :manage, Entrance::Contract
    can :statistics, Entrance::Contract
    can :manage, Entrance::UseCheck
    can :manage, Entrance::UseCheckResult
  end

  def zamestitel_otvetstvennogo_sekretarja(user)
    selection_editor(user)
    can :manage, Entrance::Exam

    can :mark, Entrance::ExamResult
    can :entrance_protocol, Office::Order
    can :update, Office::Order
    can :show, Office::Order
    can :orders, Entrance::Campaign

    can :work, :all_faculties
  end

  def executive_secretary(user)
    zamestitel_otvetstvennogo_sekretarja(user)
    can :entrance_protocol, Office::Order
    can :update, Office::Order
    can :show, Office::Order
    can :orders, Entrance::Campaign
    can :numbers, Entrance::Campaign
    can :statistics, Entrance::Contract

    can :work, :all_faculties
    # can :update, Achievement
    # can :validate_selection, Achievement

    can :manage, Entrance::Achievement
  end
end
