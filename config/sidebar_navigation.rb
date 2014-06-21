SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.dom_id = 'dashboard-menu'
    primary.dom_class = 'nav nav-pills nav-stacked'

    primary.item :actual_events, 'Актуальные события', actual_events_path,
                 icon: 'calendar'


    if user_signed_in?
      if current_user.is?(:developer)
        primary.item :dashboard, 'Обзор'.html_safe, root_path, icon: 'home'
      end

      primary.item :user_rating,
        '<span class="glyphicons podium"></span> Отчёт об эффективности'.html_safe,
                   rating_user_path(current_user)

      if current_user.is?(:subdepartment) || current_user.is?(:dean)
        primary.item :users_department,
                     '<span class="glyphicons group"></span> Подразделение'.html_safe,
                     department_users_path
      end
    end

    primary.item :nav_group_entrance, 'Приёмная кампания',
                 class: 'nav-header disabled'

    primary.item :entrance_campaign_applications,
                 '<span class="glyphicons notes_2"></span> Поданные заявления'.html_safe,
                 applications_entrance_campaign_path(Entrance::Campaign::CURRENT)

    if user_signed_in?
      if can?(:register, Entrance::Campaign)
        primary.item :entrance_campaign_register,
                     '<span class="glyphicons notes_2"></span> Регистрационный журнал'.html_safe,
                     register_entrance_campaign_path(Entrance::Campaign::CURRENT)
      end

      if can?(:manage, Entrance::Entrant)
        primary.item :new_entrance_application, 'Абитуриенты',
                     entrance_campaign_entrants_path(Entrance::Campaign::CURRENT)
      end

      primary.item :entrance_dates, 'Сроки проведения',
                   entrance_campaign_dates_path(Entrance::Campaign::CURRENT)
    end

    # ======================================
    primary.item :nav_group_study, 'Учёба', class: 'nav-header disabled'
    primary.item :progress, 'Успеваемость'.html_safe, study_groups_path, icon: 'list' do |d|
      d.dom_class = 'hidden'
      d.item :group, 'Группа', study_group_progress_path(params[:group_id] || 1)
      d.item :group_discipline, 'Группа', study_group_discipline_path(params[:group_id] || 1, params[:discipline] || 1)
      d.item :student, 'Студент', study_group_student_path(params[:group_id] || 1, params[:id] || 1)
      d.item :student_discipline, 'Студент', study_group_progress_discipline_path(params[:group_id] || 1, params[:id] || 1, params[:discipline] || 1)
    end
    if user_signed_in?
      if can? :manage, Study::Discipline
        primary.item :disciplines, 'Балльно-рейтинговая система', study_disciplines_path, icon: 'briefcase', highlights_on: -> { params[:controller].include?('disciplines') || params[:controller].include?('checkpoints') || params[:controller].include?('marks')} do |d|
          d.dom_class = 'hidden'
          d.item :edit, 'Редактирование', edit_study_discipline_path(params[:id] || 1)
          d.item :new_checkpoints, 'Расписание', new_study_discipline_checkpoint_path(params[:discipline_id] || 1)
          d.item :checkpoints, 'Карта дисциплины', study_discipline_checkpoints_path(params[:discipline_id] || 1)
          d.item :marks, 'Внесение результатов', study_discipline_checkpoint_marks_path(params[:discipline_id] || 1, params[:checkpoint_id] || 1)
        end
      end
      if can? :manage, :ciot
        primary.item :ciot, 'Логины и пароли', "#{root_url}ciot", icon: 'folder-open', highlights_on: -> { params[:controller].include?('ciot') }
      end

      if can? :manage, :all
        primary.item :brs, 'Заполненение БРС'.html_safe, print_disciplines_study_disciplines_path, icon: 'list'
      end
    end

    # ======================================
    if user_signed_in?
      if current_user.is?(:developer)
        primary.item :nav_group_lists, 'Списки', class: 'nav-header disabled'
        primary.item :roles,        'Роли'.html_safe, roles_path, icon: 'tags', highlights_on: -> { 'roles' == params[:controller] }
        primary.item :appointments, 'Должности'.html_safe, appointments_path, icon: 'tags'
        primary.item :departments,  'Структура'.html_safe, departments_path, icon: 'list', highlights_on: -> { 'departments' == params[:controller] }
        primary.item :users,        'Сотрудники'.html_safe, users_path, icon: 'user', highlights_on: -> { 'users' == params[:controller] }
        primary.item :activity_group, 'Группы показателей эффективности НПР',
                     activity_groups_path, icon: 'list'
        primary.item :activity_type, 'Типы показателей эффективности НПР',
                     activity_types_path, icon: 'list'
        primary.item :activity_credit_type, 'Типы баллов показателей эффективности НПР',
                     activity_credit_types_path, icon: 'list'
        primary.item :activity, 'Показатели эффективности НПР',
                     activities_path, icon: 'list'

        primary.item :achievement_period, 'Периоды ввода достижений НПР',
                     achievement_periods_path, icon: 'list'

        primary.item :event_categories, 'Категории событий', event_categories_path, icon: 'th-list'

        primary.item :specialities, 'Направления'.html_safe, specialities_path, icon: 'list', highlights_on: -> { 'specialities' == params[:controller] }
        primary.item :students,     'Студенты'.html_safe, students_path, icon: 'user', highlights_on: -> { 'students' == params[:controller] }
        primary.item :blanks, 'Бланки документов', blanks_path, icon: 'file'
        primary.item :groups,     'Группы'.html_safe, groups_path, icon: 'user', highlights_on: -> { 'groups' == params[:controller] }
      end
    end

    # ======================================
    if user_signed_in?
      if (can? :index, :selection_contracts) or (can? :index, :payment_types)
        primary.item :nav_group_selection, 'Платный приём', class: 'nav-header disabled'
      end
      if can? :index, :selection_contracts
        primary.item :documents,    'Ход платного приёма'.html_safe, selection_contract_path, icon: 'usd', highlights_on: -> { params[:controller].include?('selection') }
      end
      if can? :index, :payment_types
        primary.item :prices,    'Стоимость обучения'.html_safe, finance_payment_types_path, icon: 'credit-card', highlights_on: -> { params[:controller].include?('payment_types') }
      end
    end

    # ======================================
    if user_signed_in?
      if (can? :manage, :plans) or (can? :manage, Graduate)
        primary.item :nav_group_institutes, 'Дирекции', class: 'nav-header disabled'
      end
      if can? :manage, :plans
        primary.item :plans, 'Учебные планы'.html_safe, study_plans_path, icon: 'bell'
      end
      if can? :manage, :all
        primary.item :control, 'Контроль ведомостей'.html_safe, study_control_path, icon: 'warning-sign'
      end
      if can? :manage, Graduate
        primary.item :graduates, 'Выпускники', graduates_path, icon: 'folder-open'
      end
    end

    # ======================================
    if user_signed_in?
      if can? :manage, :library
        primary.item :library, 'Библиотека', class: 'nav-header disabled'
        primary.item :library_cards, 'Создать читательский билет'.html_safe, library_cards_path, icon: 'book', highlights_on: -> { params[:controller].include?('library') }
      end
    end


    # ======================================
    if user_signed_in?
      if (can? :actual, :curator_tasks) or (can? :manage, Curator::Task) or (can? :manage, Hostel::Offense)
        primary.item :nav_group_curator, 'Кураторы', class: 'nav-header disabled'
      end
      if can? :actual, :curator_tasks
        primary.item :curator, 'Работа куратора <b class="caret"></b>'.html_safe, '#', icon: 'tags', link: { :'data-toggle' => 'dropdown', class: 'dropdown-toggle'} do |curator|
          curator.dom_class = 'dropdown-menu'
          curator.item :tasks, 'Задания', actual_curator_tasks_path
          #curator.item :divider, '', nil, class: 'divider'
          curator.item :hostel, 'Проверка общежития', hostel_reports_path, class: 'hidden'
          curator.item :edit, 'Редактирование', edit_hostel_report_path(params[:id] || 1), class: 'hidden'
          curator.item :edit, 'Просмотр', hostel_report_path(params[:id] || 1), class: 'hidden'
          curator.item :new, 'Создание', new_hostel_report_path, class: 'hidden'
          curator.item :example, 'Образец', example_hostel_reports_path, class: 'hidden'
        end
      end
      if can? :manage, Curator::Task
        primary.item :task_types, 'Типы заданий для кураторов', curator_task_types_path, icon: 'inbox' do |d|
          d.dom_class = 'hidden'
          d.item :edit, 'Редактирование', edit_curator_task_type_path(params[:id] || 1)
          d.item :new, 'Создание', new_curator_task_type_path
        end
        primary.item :tasks, 'Задания для кураторов', curator_tasks_path, icon: 'bullhorn' do |d|
          d.dom_class = 'hidden'
          d.item :edit, 'Редактирование', edit_curator_task_path(params[:id] || 1)
          d.item :show, 'Просмотр', curator_task_path(params[:id] || 1)
          d.item :new, 'Создание', new_curator_task_path
        end

        primary.item :hostel_reports, 'Акты проверки общежитий', ready_hostel_reports_path, icon: 'inbox' do |d|
          d.dom_class = 'hidden'
          d.item :edit, 'Редактирование', edit_hostel_report_path(params[:id] || 1)
          d.item :new, 'Просмотр', hostel_report_path(params[:id] || 1)
        end
      end

      if can? :manage, Hostel::Offense
        primary.item :offenses, 'Типы нарушений (общежитие)', hostel_offenses_path, icon: 'inbox' do |d|
          d.dom_class = 'hidden'
          d.item :edit, 'Редактирование', edit_hostel_offense_path(params[:id] || 1)
          d.item :new, 'Создание', new_hostel_offense_path
        end
      end
    end

    # ======================================
    primary.item :nav_group_soc, 'ЦСПиВР', class: 'nav-header disabled'
    primary.item :support_form, 'Оставить заявление на мат. помощь', supports_students_path, icon: 'ok' do |d|
      d.dom_class = 'hidden'
      d.item :new, 'Создание', new_student_support_path(params[:student_id] || 1)
    end
    if user_signed_in?
      if can? :manage, My::Support
        primary.item :social_applications, 'Заявления на мат. помощь', social_applications_path, icon: 'file'
        primary.item :support, 'СПИСКИ по заявлениям'.html_safe,  lists_social_applications_path, icon: 'list'
        primary.item :support_form, 'Оставить заявление на мат. помощь', 'http://matrix3.mgup.ru/my/support', icon: 'ok'
      end
      if can? :manage, Event.new(event_category_id: EventCategory::MEDICAL_EXAMINATION_CATEGORY)
        primary.item :event,    'Профосмотр сотрудников'.html_safe, event_path(1), icon: 'calendar'
        primary.item :without_med, 'Незаписавшиеся на медосмотр'.html_safe, without_med_users_path, icon: 'print'
      end
      if can? :manage, EventDate
        primary.item :dates,    'Профосмотр (выбор даты)'.html_safe, event_dates_path(1), icon: 'calendar'
      end
    end

    # ======================================
    if user_signed_in?
      if can? :manage, Event.new(event_category_id: EventCategory::SOCIAL_EVENTS_CATEGORY)
        primary.item :nav_group_events, 'Мероприятия', class: 'nav-header disabled'
        primary.item :events, 'Мероприятия', events_path, icon: 'folder-open' do |d|
          d.dom_class = 'hidden'
          d.item :edit, 'Редактирование', edit_event_path(params[:id] || 2)
          d.item :new, 'Создание', new_event_path
        end
      end
    end

    # ======================================
    if user_signed_in?
      if current_user.is?(:developer)
        primary.item :nav_group_orders, 'Приказы', class: 'nav-header disabled'
        primary.item :office_orders, raw('Работа с приказами <span class="caret"></span>'), office_orders_path, icon: 'file', class: 'dropdown',  link: { :'data-toggle' => 'dropdown', :'class' => 'dropdown-toggle' } do |orders|
          orders.dom_class = 'dropdown-menu'
          orders.item :orders_drafts, 'Черновики приказов', drafts_office_orders_path, icon: 'paperclip'
          orders.item :orders_underways, 'Приказы на подписи', underways_office_orders_path, icon: 'time'

          orders.item :order_templates, 'Шаблоны', office_order_templates_path, icon: 'list'
        end
      end
    end

    # ======================================
    if user_signed_in?
      if (can? :index, Rating) or (can? :manage, Achievement)
        primary.item :nav_group_npr, 'Показатели эффективности', class: 'nav-header disabled'
      end
      if can? :index, Rating
        primary.item :ratings, 'Показатели эффективности', ratings_path, icon: 'stats'
      end
      if can? :manage, Achievement
        # primary.item :periods_achievements, 'Показатели эффективности',
        #              periods_achievements_path, icon: 'stats' do |a|
        #   a.dom_class = 'hidden'
        #   a.item :achievements, 'Отчёт за период', achievements_path
        # end

        # if can? :validate, Achievement
        #   primary.item :validate_achievements, 'Подтверждение показателей эффективности (кафедра)',
        #                validate_achievements_path, icon: 'check'
        # end

        # if can? :validate_selection, Achievement
        #   primary.item :validate_selection_achievements, 'Подтверждение показателей эффективности (профориентационная работа, работа по привлечению контингента и работа в приёмной комиссии)',
        #                validate_selection_achievements_path, icon: 'check'
        # end

        # if can? :validate_social, Achievement
        #   primary.item :validate_social_achievements, 'Подтверждение показателей эффективности (работа куратором)',
        #                validate_social_achievements_path, icon: 'check'
        # end

        if can? :validate_additional, Achievement
        #if current_user.is?(:dean)
          primary.item :validate_additional_achievements, 'Подтверждение показателей эффективности (поручения директора)',
                       validate_additional_achievements_path, icon: 'check'
        end
      end
      if can? :manage, :all
        primary.item :npr, 'Заполненение НПР'.html_safe, print_achievements_path, icon: 'list'
      end
    end

    if student_signed_in?
      primary.item :my_student, 'Информация', my_student_path, icon: 'user'
    end
  end


  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  navigation.renderer = SidebarRenderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  #navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #
    #primary.item :key_1, 'name', url, options

    # Add an item which has a sub navigation (same params, but with block)
    #primary.item :key_2, 'name', url, options do |sub_nav|
      # Add an item to the sub navigation (same params again)
      #sub_nav.item :key_2_1, 'name', url, options
    #end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    #primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    #primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  #end

end
