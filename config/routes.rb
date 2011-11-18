ActionController::Routing::Routes.draw do |map|

#
#	from simply_authorized
#
#	map.resources :users, :only => [:destroy,:show,:index],
#		:collection => { :menu => :get } do |user|
#		user.resources :roles, :only => [:update,:destroy]
#	end


#	from calnet_authenticated
	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
	map.resources :users, :only => [:destroy,:show,:index],
		:collection => { :menu => :get } do |user|
		user.resources :roles, :only => [:update,:destroy]
	end
	map.resource :session, :only => [ :destroy ]



#	map.logout 'logout', :controller => 'sessions', :action => 'destroy'
#	map.resource :session, :only => [ :destroy ]

	map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'

	map.connect 'javascripts/:action.:format', :controller => 'javascripts'

#	map.resources :users, :only => [:destroy,:show,:index],
#		:collection => {
#			:menu => :get
#		} do |user|
#		user.resources :roles, :only => [:update,:destroy]
#	end

	map.resource  :calendar,   :only => [ :show ]
	map.resources :races
	map.resources :languages
	map.resources :people
	map.resources :refusal_reasons
	map.resources :ineligible_reasons
	map.resources :zip_codes, :only => [ :index ]

end
