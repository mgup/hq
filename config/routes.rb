HQ::Application.routes.draw do
  devise_for :users

  # Мониторинг состояния сервера.
  get 'system/stats'

  get 'utility/morpher'

  resources :roles
  resources :users
  resources :departments
  resources :positions

  resources :students

  resources :specialities

  namespace :study do
    resources :subjects do
      resources :marks
    end
  end

  get 'schedule/data/departments' => 'schedule/data#departments'
  get 'schedule/data/rooms' => 'schedule/data#rooms'

  get 'study/subjects/ajax/specialities' => 'ajax#specialities'
  get 'study/subjects/ajax/groups' => 'ajax#groups'

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
