HQ::Application.routes.draw do
  devise_for :users #, skip: :registrations
  devise_for :students

  # Мониторинг состояния сервера.
  get 'system/stats'

  get 'utility/morpher'

  get '/password' => 'password#index'
  get '/ciot(/:page)', to: 'ciot#index'

  resources :roles
  resources :users do
    get 'profile' => 'users#profile'
  end
  get 'users_filter' => 'users#filter'

  resources :departments
  resources :positions

  resources :groups do
    get '/print_group.pdf', to: 'groups#print_group', defaults: { format: 'pdf' }, as: :print_group
  end

  resources :students do
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
        resources :marks
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
      resources :students, path:  '/student'
      get '/student/:id/discipline/:discipline' => 'students#discipline'
    end
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
    resources :applications

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
  resources :activities

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
  get '/ajax/group_students' => 'ajax#group_students'
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
