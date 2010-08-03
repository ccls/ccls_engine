ActionController::Routing::Routes.draw do |map|

#	map.root :controller => "pages", :action => "show", :path => [""]
	map.resources :pages, :collection => { :order => :post }

	map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'
	map.connect 'javascripts/:action.:format', :controller => 'javascripts'

#	http://wiki.rubyonrails.org/rails/pages/ReservedWords
#	image - Due to that there is an image_path helper, using images as a restful route will cause issues.
#test_AWiHTTPS_should_get_index_with_admin_login(DocumentsControllerTest):
#ActionView::TemplateError: image_url failed to generate from {:controller=>"images", :action=>"show", :id=>"cal.ico"}, expected: {:controller=>"images", :action=>"show"}, diff: {:id=>"cal.ico"}
#    On line #6 of app/views/layouts/application.html.erb
#	map.resources :images
	map.resources :photos
	map.resources :documents, :member => { :preview => :get }
	map.resources :locales, :only => :show

#	map.login  'login',  :controller => 'sessions', :action => 'create'
	map.logout 'logout', :controller => 'sessions', :action => 'destroy'

#	map.login  'login',  :controller => 'user_sessions', :action => 'new'  
#	map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'  
#	#	keep user_sessions route plural or form on 'new' will fail.
#	map.resources :user_sessions, :only => [ :new, :create, :destroy ]

#	map.logout 'logout', :controller => 'sessions', :action => 'destroy'

	map.resources :sessions, :only => [ :destroy ]
	map.resources :users, :only => [:destroy,:show,:index] do |user|
		user.resources :roles, :only => [:update,:destroy]
	end
end
