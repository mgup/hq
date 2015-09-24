HQ::Application.routes.draw do
  namespace :purchase do
    resources :suppliers
    resources :goods
    resources :purchases
    resources :line_items
    get 'line_item/search_result' => 'line_items#search_result', as: :search_result
  end

  resources :universities
  resources :reviews
  get 'review/search_result' => 'reviews#search_results', as: :search_results

  resources :phonebook
  get 'phonebook/index'

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is?(:developer) } do
    mount Sidekiq::Web => '/sidekiq'
  end

  require 'sidekiq/api'
  get 'queue-status' => proc {
    [200, { 'Content-Type' => 'text/plain' },
     [Sidekiq::Queue.new.size < 100 ? 'OK' : 'UHOH' ]]
  }
  get 'queue-latency' => proc {
    [200, { 'Content-Type' => 'text/plain' },
     [Sidekiq::Queue.new.latency < 30 ? 'OK' : 'UHOH' ]]
  }

  root to: 'dashboard#index'

  match '/404' => 'errors#error404', via: [:get, :post, :patch, :delete]
  match '/500' => 'errors#error500', via: [:get, :post, :patch, :delete]

  devise_for :users, controllers: { registrations: 'users' }
    as :user do
      get 'user/edit' => 'devise/registrations#edit', as: 'user_profile'
      put 'user/user_update' => 'devise/registrations#update'
    end
  devise_for :students, controllers: {registrations: 'students'}

  # Мониторинг состояния сервера.
  get 'system/stats'

  get 'utility/morpher'

  get '/password' => 'password#index'
  get '/ciot(/:page)', to: 'ciot#index'

  resources :roles
  resources :users do
    get 'rating', on: :member

    get 'department', on: :collection

    get 'without_med.xlsx', to: 'users#without_med', on: :collection, defaults: { format: 'xlsx' }, as: :without_med
    get 'see_with_eyes' => 'users#see_with_eyes', as: :see_with_eyes
    get 'medical_requests.pdf', to: 'users#medical_requests', on: :collection, defaults: { format: 'pdf' }
  end
  get 'users_filter' => 'users#filter'

  resources :departments do
    post 'combine', on: :member
  end

  resources :events do
    get 'actual', to: 'events#actual', on: :collection
    get 'more', to: 'events#more', on: :member
    get 'calendar', to: 'events#calendar', on: :collection
    get 'print.pdf', to: 'events#print', on: :member, defaults: { format: 'pdf' }, as: :print
    resources :claims
    resources :dates do
      get 'print.pdf', to: 'dates#print', on: :member, defaults: { format: 'pdf' }, as: :print
      resources :visitor_event_dates
    end
  end
  resources :event_categories

  resources :positions
  resources :appointments

  namespace :document do
    resources :docs
  end
  resources :blanks do
    get 'transfer_protocols', on: :collection
  end

  namespace :library do
    get '/cards', to: 'cards#index', as: :cards
    get '/cards/print_all', to: 'cards#print_all', as: :print_all_cards
    get '/cards/students/:student/create', to: 'cards#create', as: :create_student_card
    get '/cards/students/:student/print', to: 'cards#print', as: :print_student_card
    get '/cards/users/:user/create', to: 'cards#create', as: :create_user_card
    get '/cards/users/:user/print', to: 'cards#print', as: :print_user_card
    get '/cards/print_card.pdf', to: 'cards#print_card', defaults: { format: 'pdf' }, as: :print_card
  end

  resources :groups do
    member do
      get 'session_call', defaults: { format: 'pdf' }
    end

    get '/print_group.pdf', to: 'groups#print_group', defaults: { format: 'pdf' }, as: :print_group
  end

  namespace :hostel do
    resources :offenses
    resources :reports do
      get 'report.pdf', to: 'reports#print', on: :member, defaults: { format: :pdf }, as: :print
      get '/ready', to: 'reports#ready', on: :collection
      get '/example', to: 'reports#example', on: :collection
    end
  end

  namespace :social do
    resources :document_types
    resources :documents, only: [] do
      get 'list', on: :collection
    end
  end
  resources :persons do
    get 'create_employer', to: 'persons#create_employer', on: :member
  end
  resources :students do
    namespace :social do
        resources :deeds, controller: 'documents'
    end
    get 'soccard', to: 'students#soccard', on: :collection
    get 'soccard_mistakes', to: 'students#soccard_mistakes', on: :collection
    get 'documents' => 'students#documents'
    get 'orders' => 'students#orders'
    get 'study' => 'students#study'
    get 'hostel' => 'students#hostel'
    get 'grants' => 'students#grants'
    get 'supports', to: 'supports#index', on: :collection
    get 'quality', to: 'students#quality', on: :collection
    get 'report.xlsx', to: 'students#report', on: :collection, defaults: { format: 'xlsx' }, as: :print_report
    resources :supports do
      get 'download_pdf.pdf', to: 'supports#download_pdf', defaults: { format: 'pdf' }, as: :student_support
      get 'options', to: 'supports#options', on: :collection
    end
    post 'reference.pdf', to: 'students#reference', on: :member, defaults: { format: :pdf }, as: :reference
    get 'petition.pdf', to: 'students#petition', on: :member, defaults: { format: :pdf }, as: :petition
  end
  get '/students/list(/:page)', to: 'students#index'

  resources :specialities

  namespace :study do
    scope ':year-:term', defaults: { year: Study::Discipline::CURRENT_STUDY_YEAR,
                                     term: Study::Discipline::CURRENT_STUDY_TERM } do
      # Учебные планы.
      get 'plans', to: 'plans#index'
      get 'control', to: 'exams#control'
    end

    resources :groups, path:  '/group' do
      get '/progress' => 'progress#index'
      get '/progress/discipline/:discipline' => 'progress#discipline', as: :discipline
      get '/progress/change_discipline' => 'progress#change_discipline'
      get '/print_progress.pdf', to: 'progress#print_progress', defaults: { format: 'pdf' }, as: :print_progress
      resources :students, path:  '/student'
      get '/student/:id/discipline/:discipline' => 'students#discipline', as: :progress_discipline
    end

    get 'exammarks/:id/ajax_update' => 'exam_marks#ajax_update'
    resources :disciplines do
      get 'manage', on: :member

      get 'print_group.pdf', to: 'disciplines#print_group', defaults: { format: 'pdf' }, as: :print_group
      get 'print_disciplines.xlsx', to: 'disciplines#print_disciplines', on: :collection, defaults: { format: 'xlsx' }, as: :print_disciplines
      match 'download_group',  to: 'checkpoints#download_pdf', via: [:get, :post]
      resources :checkpoints do
        get 'change_date', to: 'checkpoints#change_date', on: :member
        get 'update_date', to: 'checkpoints#update_date', on: :member
        resources :marks do
          get 'ajax_update', to: 'marks#ajax_update', on: :member
        end
      end

      resources :exams do
        get 'print',   on: :member, defaults: { format: 'pdf' }

        patch '/updatedate', to: 'exams#updatedate', on: :member

        resources :repeats
      end
    end

    #resources :subjects do
    #  resources :marks
    #end
    #get '/analyse' => 'analyse#index'
    #get '/chase' => 'chase#index'



    get '/plans' => 'plans#index'
    #get '/plans/:exam_id/updatedate' => 'plans#updatedate'
    get '/plans/updatediscipline' => 'plans#updatediscipline'
  end

  namespace :my do
    resource :student do
      get '/progress' => 'progress#index'
      get '/progress/subject/:id' => 'progress#subject'
      get '/progress/discipline/:id' => 'progress#discipline'
      resources :selects
      get 'download_pdf.pdf', to: 'selects#download_pdf', defaults: { format: 'pdf' }, as: :student_selects
      #get '/social/download_pdf.pdf', to: 'socials#download_pdf', defaults: { format: 'pdf' }, as: :student_social
      #get '/social' => 'socials#new'
    end
  end

  namespace :social do
    resources :applications do
      get 'lists', to: 'applications#lists', on: :collection
      get 'close', to: 'applications#close_receipt', on: :collection
      get 'print_list.xlsx', to: 'applications#print_list', on: :collection, defaults: { format: 'xlsx' }, as: :print_list
    end

    #resources :supports
    #get '/support/claims' => 'supports#claims'
  end

  namespace :office do
    resources :orders, except: [:show] do
      # get '/', to: 'orders#show', defaults: { format: 'pdf' }, as: :show
      # get 'drafts', to: 'orders#drafts', on: :collection
      # get 'underways', to: 'orders#underways', on: :collection
      get 'entrance_protocol', to: 'orders#entrance_protocol', on: :member
      get 'rebukes', to: 'orders#rebukes', on: :collection
    end
    resources :orders, only: [:show],
                       defaults: { format: 'pdf' },
                       constraints: { format: /(pdf|xml)/ }


    get 'drafts', to: 'orders#drafts'
    get 'underways', to: 'orders#underways'
    get 'orders/new(/:page)', to: 'orders#new', defaults: { page: 1 }



    resources :order_templates do
      resources :order_blanks
    end
  end

  namespace :finance do
    resources :payment_types
    get '/prices_filter' => 'payment_types#prices_filter'
    get 'print_prices.xlsx', to: 'payment_types#print_prices',
        defaults: { format: 'xlsx' }, as: :print_prices
  end

  namespace :curator do
    resources :tasks do
      get 'actual', to: 'tasks#actual', on: :collection
      get 'analyze', to: 'tasks#analyze', on: :collection
      get 'print_tasks.xlsx', to: 'tasks#print_tasks', defaults: { format: 'xlsx' }, as: :print_tasks, on: :collection
    end
    resources :task_types
    resources :task_users
    resources :groups
  end


  resources :activity_groups
  resources :activity_types
  resources :activity_credit_types
  resources :activities

  resources :ratings
  resources :achievement_periods
  resources :achievements do
    get 'test',  on: :collection
    get 'periods',  on: :collection
    get 'print.xlsx', to: 'achievements#print', on: :collection, defaults: { format: 'xlsx' }, as: :print
    get 'validate', on: :collection
    get 'validate_selection', on: :collection
    get 'validate_social', on: :collection
    get 'validate_additional', on: :collection
    get 'calculate', on: :collection
    get 'salary_igrik',    on: :collection
    get 'salary_iidizh',    on: :collection
    get 'salary_ikim',    on: :collection
    get 'salary_ipit',    on: :collection
    get 'calculate_salary', on: :collection
  end
  resources :achievement_reports do
    get 'reopen', on: :member
  end


  # Информация о платном приёме
  # get 'selection/contract(/:page)', to: 'selection#contract', defaults: { page: 1 }, as: :selection_contract

  get 'schedule/data/departments' => 'schedule/data#departments'
  get 'schedule/data/rooms' => 'schedule/data#rooms'

  get 'study/ajax/subjects' => 'ajax#subjects'
  get 'study/ajax/disciplines' => 'ajax#disciplines'
  get 'hostel/ajax/flats' => 'ajax#flats'
  get 'hostel/ajax/rooms' => 'ajax#rooms'
  get 'hostel/ajax/students' => 'ajax#flat_students'
  get '/study/disciplines/ajax/groups' => 'ajax#groups'
  get '/study/disciplines/ajax/specialities' => 'ajax#specialities'
  get 'my/ajax/students' => 'ajax#students'
  get '/ajax/checkpoint' => 'ajax#checkpoint'
  get '/ajax/users' => 'ajax#users'
  get '/ajax/count_final' => 'ajax#count_final'
  get '/ajax/teachers' => 'ajax#teachers'
  get '/ajax/group_students' => 'ajax#group_students'
  get '/ajax/group_exams' => 'ajax#group_exams'
  get '/ajax/orderstudent' => 'ajax#orderstudent'
  get '/ajax/ordermeta' => 'ajax#ordermeta'
  get '/ajax/orderreason' => 'ajax#orderreason'


  resources :education_prices, only: [:index]

  resources :directions, only: :index
  namespace :entrance do
    get 'import' => 'import#index'
    resources :items do
      get 'protocols', on: :collection, defaults: { format: :pdf }
    end
    resources :campaigns do
      member do
        get 'paid_enrollment'
        get 'conflicts'
        get 'ratings'
        get 'protocol_permit'
        get 'choice'
      end
      
      resources :achievements do
          get 'ajax_update', to: 'achievements#ajax_update', on: :member
      end
      get 'temp_print_all_checks', on: :member

      get 'dashboard', on: :member

      get 'applications', on: :member
      get 'print_all', on: :member, defaults: { format: :pdf }
      get 'report',       on: :member
      get 'register',     on: :member
      get '/print_department_register.pdf', to: 'campaigns#print_department_register', on: :member, defaults: { format: 'pdf' }, as: :print_department_register
      get 'rating',     on: :member
      get 'crimea_rating',     on: :member
      get 'results',     on: :member
      get 'balls',     on: :member
      get 'orders', on: :collection
      get 'numbers', on: :collection

      resources :dates
      resources :exams do
        resources :exam_results do
          get 'ajax_update', to: 'exam_results#ajax_update', on: :member
        end
      end
      resources :min_scores
      resources :events
      resources :contracts do
        get 'statistics', to: 'contracts#statistics', on: :collection
      end
      resources :entrants do
        get 'history', on: :member
        get 'events', on: :member
        get 'check', on: :collection
        resources :exam_results
        resources :checks do
          get 'show.pdf', to: 'checks#show', on: :member, defaults: { format: 'pdf' }, as: :print
        end

        # get 'checks/:id/show.pdf', to: 'checks#show', on: :member, defaults: { format: 'pdf' }, as: :check

        resources :event_entrants
        resources :applications do
          get '/enroll', to: 'applications#enroll', on: :member, as: :enroll
          member do
            get 'reject'
          end
          resource :contract

          get 'send_to_order', on: :member

          get '/print.pdf', to: 'applications#print', on: :member, defaults: { format: 'pdf' }, as: :print
          get '/print_all.pdf', to: 'applications#print_all', on: :collection, defaults: { format: 'pdf' }, as: :print_all
        end
      end

      post 'fis/clear'       => 'fis#clear'
      get 'fis/clear'       => 'fis#clear'
      get 'fis/clear-check' => 'fis#clear_check'
      get 'fis/check-use'   => 'fis#check_use'
      post 'fis/check'   => 'fis#check'

      get 'fis/test'  => 'fis#test'
      get 'fis/kladr' => 'fis#kladr'
    end

    resources :document_movements
  end

  namespace :report do
    get 'structure/report', to: 'structure#report', defaults: { format: :xlsx }

    get 'gzgu/mon_pk',  to: 'gzgu#mon_pk'
    get 'gzgu/mon_pk_f1_2014_06_23',  to: 'gzgu#mon_pk_f1_2014_06_23'
    get 'gzgu/mon_pk_f1a_2014_06_23', to: 'gzgu#mon_pk_f1a_2014_06_23'
    get 'gzgu/mon_pk_f2_2014_06_23',  to: 'gzgu#mon_pk_f2_2014_06_23'
  end

  get 'fractals-radial', to: 'fractals#radial'
  get 'test-exception', to: 'dashboard#test_exception'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
