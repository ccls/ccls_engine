ActionController::Routing::Routes.draw do |map|
	map.logout 'logout', :controller => 'sessions', :action => 'destroy'

#	map.login  'login',  :controller => 'user_sessions', :action => 'new'  
#	map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'  
#	#	keep user_sessions route plural or form on 'new' will fail.
#	map.resources :user_sessions, :only => [ :new, :create, :destroy ]

#	map.logout 'logout', :controller => 'sessions', :action => 'destroy'

	map.resources :sessions, :only => [ :destroy ]
	map.resources :users, :only => [:show, :index] do |user|
		user.resources :roles, :only => [:update,:destroy]
	end
end
