ActionController::Routing::Routes.draw do |map|
  map.resources :statuses

  map.resources :degrees

  map.resources :educations

  map.resources :stations

  map.resources :ret_salary_details

  map.resources :profiles, :collection => { :change_my_password => :get, :my_profile => :get}

  map.resources :total_stats

  map.resources :salary_details

  map.resources :assistant_benefit_confirms

  map.resources :assistant_benefit_sets

  map.resources :assistant_benefits

  map.resources :tips

  map.resources :temp5s

  map.resources :temp4s

  map.resources :temp3s

  map.resources :temp2s

  map.resources :temp1s, :collection => { :data_import => :get }

  map.resources :performance_benefit_records

  map.resources :performance_benefit_stds

  map.resources :welfare_benefits

  map.resources :class_month_benefit_records

  map.resources :undefind_fees, :collection => {:deliver => :get}

  map.resources :app_configs

  map.resources :station_position_benefit_records

  map.resources :class_be_personnels

  map.resources :class_be_edus

  map.resources :science_be_personnels

  map.resources :science_be_sciences

  map.resources :station_position_benefits

  map.resources :retired_fee_cutting_records

  map.resources :retired_college_be_records

  map.resources :retired_basic_salary_records

  map.resources :retired_fee_cuttings

  map.resources :retired_college_benefits

  map.resources :assistants

  map.resources :retired_basic_salaries

  map.resources :college_be_records

  map.resources :college_benefits

  map.resources :fee_cutting_records

  map.resources :basic_salary_records

  map.resources :fee_cuttings

  map.resources :basic_salaries

  map.resources :bank_cards

  map.resources :banks

  map.resources :role_users

  map.resources :users

  map.resources :positions

  map.resources :titles

  map.resources :departments do |departments|
    departments.resources :users
  end

  map.resources :page_roles

  map.resources :roles

  map.resources :pages

  map.resources :page_modules


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.root :controller => 'admin', :action => 'index'
  map.connect '/departments/users_to_json', :controller => "departments", :action => "users_to_json"
  map.connect ':controller/:action', :controller => ["admin,data_import,data_backup,temp1s,welcome"]
  map.connect '/logout', :controller => 'admin', :action => 'logout'
  map.connect '/signin', :controller => 'admin', :action => 'login'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
