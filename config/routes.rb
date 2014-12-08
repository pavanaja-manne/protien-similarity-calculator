Similarity::Application.routes.draw do
  get "visualization/time"
  root "home#index"
  get "calculator/cosine"
  get "calculator/cosine_parallel"
  get "calculator/jaccard"
  get "calculator/cosine_inverted_index"
  get "calculator/cosine_storage_parallel"

  get "/uploadFiles" => "home#uploadFiles"
  get "/cosineSequenceGraph" => "visualization#graph_sequence"
  get "/cosineParallelGraph" => "visualization#graph_parallel"
  get "/jaccardGraph" => "visualization#jaccardVisualization"

  get "/visualization/loadTimeParallel"
  get "/visualization/loadTimeSequence"
  get "/visualization/loadJaccardVisualSequence"
  

  post "/file_upload_cosine" => "file_upload#cosine_file_upload"
  post "/file_upload_jaccard" => "file_upload#jaccard_file_upload"


  #get "calculator/jaccard-tanimoto"
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
