Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users		#gives us all the REST-ful URLs (new, show, etc)
  resources :sessions, :only => [:new, :create, :destroy]	#restrict to new, create, and destroy only
  resources :microposts, :only => [:create, :destroy]
  
  #physical files take priority over this route. delete/rename index.html
  root :to => 'pages#home'

  #above line also enables use of root_path in link_to, i.e.
  #<%= link_to "Home", root_path %>
	
  # mod_rewrite, Rails style
  # pages#contact = controller#action (new to rails 3, merged from MERB)
  get '/contact', :to => "pages#contact"
  get '/about', :to => "pages#about"
  get '/help', :to => "pages#help"
  get '/signup', :to => "users#new"
  #match 'signup' gives us the named route signup_path that we use in link_to

  get '/signin', :to => "sessions#new"
  get '/login', :to => "sessions#new"
  get '/signout', :to => "sessions#destroy"
  get '/logout', :to => "sessions#destroy"

  #typos lead to Routing Error uninitialized ____Controller
  #i.e. if you use user#new instead of users#new

  #match allows you to use XXX_path later in a View (template), i.e.
  #<%= link_to "About", about_path %> spits out a 

	##################
  #Out of the box, we had
  # get "pages/home"
  # get "pages/about"...etc
  #but turned off to avoid having /pages/ in URL



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end


# SampleApp::Application.routes.draw do 
# ...