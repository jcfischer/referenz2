ActionController::Routing::Routes.draw do |map|

  map.resources :comments
  map.resources :tests
  
  map.resources :users, :member => { :activate => :get,
                                     
                                     :suspend   => :put,
                                     :unsuspend => :put,
                                     :purge     => :delete },
                        :collection => { :reactivate => :post,
                                         :activation => :get}


  map.resource :session


  map.resources :pages, :member => { :publish => :get, :draft => :put } do |page|
    page.resources :comments do |comment|
      comment.resources :comments
    end
  end
  
  map.namespace :admin do |admin|
    admin.resources :comments, :collection => { :delete_many => :delete }
    admin.resources :pages, :collection => { :delete_many => :delete }
    admin.resources :users, :collection => { :delete_many => :delete }
    admin.resources :erratas, :collection => { :delete_many => :delete }
    admin.resources :chapters do |chapter|
      chapter.resources :sections
    end
  end
  
  map.danke    '/erratas/danke', :controller => 'erratas', :action => 'thanks'
  
  map.resources :categories
  map.resources :erratas
  map.resources :sections
  map.resources :chapters do |chapter|
    chapter.resources :sections
  end

  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.signup   '/signup', :controller => 'users', :action => 'new'
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout   '/logout', :controller => 'sessions', :action => 'destroy'   
  
  map.download '/download/:file.:ext', :controller => 'files', :action => 'download'
  
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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "page", :action => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
