HQ::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  devise_for :students

  # Мониторинг состояния сервера.
  get 'system/stats'

  get 'utility/morpher'

  get '/password' => 'password#index'
  get '/ciot(/:page)', to: 'ciot#index'

  resources :roles
  resources :users do
    get 'profile' => 'users#profile'

    get 'medical_requests.pdf', to: 'users#medical_requests', on: :collection, defaults: { format: 'pdf' }
  end
  get 'users_filter' => 'users#filter'

  resources :departments do
    post 'combine', on: :member
  end

  resources :positions
  resources :appointments

  resources :groups do
    get '/print_group.pdf', to: 'groups#print_group', defaults: { format: 'pdf' }, as: :print_group
  end

  resources :students do
    get 'documents' => 'students#documents'
    resources :supports
    get 'download_pdf.pdf', to: 'supports#download_pdf', defaults: { format: 'pdf' }, as: :student_support

    get 'reference', on: :member, defaults: { format: :pdf }
  end
  get '/students/list(/:page)', to: 'students#index'

  resources :specialities

  namespace :study do
    resources :disciplines do
      get 'print_group.pdf', to: 'disciplines#print_group', defaults: { format: 'pdf' }, as: :print_group
      get 'print_disciplines.xlsx', to: 'disciplines#print_disciplines', on: :collection, defaults: { format: 'xlsx' }, as: :print_disciplines
      match 'download_group',  to: 'checkpoints#download_pdf', via: [:get, :post]
      resources :checkpoints do
        resources :marks do
          get 'ajax_update', to: 'marks#ajax_update', on: :member
        end
      end
      resources :exams do
        get '/print.pdf', to: 'exams#print', defaults: { format: 'pdf' }, as: :print
      end
    end

    #resources :subjects do
    #  resources :marks
    #end
    #get '/analyse' => 'analyse#index'
    #get '/chase' => 'chase#index'

    resources :groups, path:  '/group' do
      get '/progress' => 'progress#index'
      get '/progress/change_discipline' => 'progress#change_discipline'
      get '/print_progress.pdf', to: 'progress#print_progress', defaults: { format: 'pdf' }, as: :print_progress
      resources :students, path:  '/student'
      get '/student/:id/discipline/:discipline' => 'students#discipline'
    end

    get '/plans' => 'plans#index'
    get '/plans/add_discipline' => 'plans#add_discipline'
    get '/plans/edit_discipline' => 'plans#edit_discipline'
    get '/plans/repeat' => 'plans#repeat'
    get '/plans/:exam_id/updatedate' => 'plans#updatedate'
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
      get 'print_list.xlsx', to: 'applications#print_list', on: :collection, defaults: { format: 'xlsx' }, as: :print_list
    end

    #resources :supports
    #get '/support/claims' => 'supports#claims'
  end

  namespace :office do
    resources :orders do
      get 'drafts', to: 'orders#drafts', on: :collection
      get 'underways', to: 'orders#underways', on: :collection
    end
    get 'orders/new(/:page)', to: 'orders#new', defaults: { page: 1 }

    resources :order_templates do
      resources :order_blanks
    end
  end

  namespace :finance do
    resources :payment_types, path:  '/price'
    get '/prices_filter' => 'payment_types#prices_filter'
    get 'print_prices.xlsx', to: 'payment_types#print_prices', defaults: { format: 'xlsx' }, as: :print_prices
  end

  resources :activity_groups
  resources :activity_types
  resources :activity_credit_types
  resources :activities

  resources :achievement_periods
  resources :achievements do
    get 'periods', on: :collection
  end

  get 'selection/contract(/:page)', to: 'selection#contract', defaults: { page: 1 }, as: :selection_contract

  get 'schedule/data/departments' => 'schedule/data#departments'
  get 'schedule/data/rooms' => 'schedule/data#rooms'

  get 'study/ajax/subjects' => 'ajax#subjects'
  get 'study/ajax/disciplines' => 'ajax#disciplines'
  get '/study/disciplines/ajax/groups' => 'ajax#groups'
  get '/study/disciplines/ajax/specialities' => 'ajax#specialities'
  get 'my/ajax/students' => 'ajax#students'
  get '/ajax/checkpoint' => 'ajax#checkpoint'
  get '/ajax/users' => 'ajax#users'
  get '/ajax/teachers' => 'ajax#teachers'
  get '/ajax/group_students' => 'ajax#group_students'
  get '/ajax/group_exams' => 'ajax#group_exams'
  get '/ajax/orderstudent' => 'ajax#orderstudent'

  root to: 'dashboard#index'

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
