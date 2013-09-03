class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_a?(Student)
      # Набор разрешений для студентов.
      can :show, Student, student_group_id: user.id
    else
      #if user.is?(:typer)
      #  can [:create, :read], [Study::Subject, Study::Mark], user_id: user.id
      #  can :update, Study::Mark, user_id: user.id
      #end
      #
      #if user.is?(:supertyper)
      #  can :manage, [Study::Subject, Study::Mark]
      #end

      if user.is?(:zamestitel_otvetstvennogo_sekretarja)
        can :index, :selection_contracts
      end

      if user.is?(:chief_accountant)
        can :index, :selection_contracts
      end

      if user.is?(:lecturer)
        can :manage, Study::Discipline
        can :manage, Study::Checkpoint
        # Загрузка ресурсов, принадлежащих только текущему пользователю,
        # производится в Study::DisciplinesController.
        #can :manage, [Study::Discipline], Study::Discipline.include_teacher(user) { |d| }
      end

      if user.is?(:developer)
        can :manage, :all
      end
    end

    can [:index, :show], :progress
    can :show, [:student_progress, :student_discipline_progress]
    can :manage, :progress_group

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
