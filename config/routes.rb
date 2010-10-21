ActionController::Routing::Routes.draw do |map|

	map.resources :pages, :collection => { 
		:translate => :get,
		:order => :post }

	map.connect 'stylesheets/:action.:format', :controller => 'stylesheets'

	map.connect 'javascripts/:action.:format', :controller => 'javascripts'

	map.resources :documents, :member => { :preview => :get }

	map.resources :locales, :only => :show

	map.resources :users, :only => [:destroy,:show,:index],
		:collection => {
			:menu => :get
		} do |user|
		user.resources :roles, :only => [:update,:destroy]
	end

end
