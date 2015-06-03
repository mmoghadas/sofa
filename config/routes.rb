Rails.application.routes.draw do

  resources :watchdogs
  # test routes
  match '/nothing' => 'application#get_nothing', via: :get
  match '/nothing' => 'application#post_nothing', via: :post

  # api key route
  match '/api_key/generate' => 'api_key#generate', via: :post

  # couchdb routes
  match '/couchrest/state' => 'couchrest#get_state', via: :get
  match '/couchrest/healthy' => 'couchrest#get_healthy', via: :get
  match '/couchrest/unhealthy' => 'couchrest#get_unhealthy', via: :get
  match '/couchrest/update_state' => 'couchrest#update_state', via: :post

  # mongo_driver routes
  match '/mongo_driver/state' => 'mongo_driver#get_state_mongo', via: :get
  match '/mongo_driver/healthy' => 'mongo_driver#get_healthy_mongo', via: :get
  match '/mongo_driver/unhealthy' => 'mongo_driver#get_unhealthy_mongo', via: :get
  match '/mongo_driver/update_state' => 'mongo_driver#update_state_mongo', via: :post

  # mongoid routes
  match '/mongoid/state' => 'watchdogs#get_state', via: :get
  match '/mongoid/healthy' => 'watchdogs#get_healthy', via: :get
  match '/mongoid/unhealthy' => 'watchdogs#get_unhealthy', via: :get
  match '/mongoid/update_state' => 'watchdogs#update_state', via: :post



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
