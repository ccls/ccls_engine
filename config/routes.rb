ActionController::Routing::Routes.draw do |map|

#	All controllers and functional tests have been removed
#	however, the helper tests actually need the routes defined
#	by the following ...

	map.resources :users, :only => [:index] do |user|
#		:collection => { :menu => :get } do |user|
		user.resources :roles, :only => [:update,:destroy]
	end


#
##
##	from simply_authorized
##
##	map.resources :users, :only => [:destroy,:show,:index],
##		:collection => { :menu => :get } do |user|
##		user.resources :roles, :only => [:update,:destroy]
##	end
#
#
#	from calnet_authenticated
#	map.resources :users, :only => [:destroy,:show,:index],
#		:collection => { :menu => :get } do |user|
#		user.resources :roles, :only => [:update,:destroy]
#	end
#	map.resource :session, :only => [ :destroy ]
#	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
#
#
#
##	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
##	map.resource :session, :only => [ :destroy ]
#
#	map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'
#
#	map.connect 'javascripts/:action.:format', :controller => 'javascripts'
#
##	map.resources :users, :only => [:destroy,:show,:index],
##		:collection => {
##			:menu => :get
##		} do |user|
##		user.resources :roles, :only => [:update,:destroy]
##	end
#
#	map.resource  :calendar,   :only => [ :show ]
##	map.resources :races
##	map.resources :languages
##	map.resources :people
##	map.resources :refusal_reasons
##	map.resources :ineligible_reasons
#	map.resources :zip_codes, :only => [ :index ]
#
#
#
#
#	map.resources :locales, :only => :show
#
#	map.root :controller => "pages", :action => "show", :path => [""]
#
#	#	MUST BE LAST OR WILL BLOCK ALL OTHER ROUTES!
#	#	catch all route to manage admin created pages.
#	map.connect   '*path', :controller => 'pages', :action => 'show'
#
end
