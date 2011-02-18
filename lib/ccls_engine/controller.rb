require 'action_controller'

#	Further info regarding UCB's CAS setup can be found at 
#	https://calnet.berkeley.edu/developers/developerResources/cas/CASAppSetup.html#firstLevelServers

module Ccls::Controller

	#	Setup the CASClient and add the cas_filter before_filter
	#	to all application_controller requests.  This can be
	#	overridden or "skipped" in any controller, particularly
	#	those that are passive and will use the cas_gateway_filter
	#	instead.
	def self.included(base)
		base_server_url = ( RAILS_ENV == "production" ) ? 
			"https://auth.berkeley.edu" : 
			"https://auth-test.berkeley.edu"

		CASClient::Frameworks::Rails::Filter.configure(
			:username_session_key => :calnetuid,
			:cas_base_url => "#{base_server_url}/cas/"
		)

		base.helper_method :current_user, :logged_in?

		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)

		base.class_eval do
			class << self
				alias_method_chain :inherited, :ccls_calnet_before_filter
			end
		end
	end

module ClassMethods

private

	def inherited_with_ccls_calnet_before_filter(base)
		identifier = 'inherited_ccls_calnet_authenticated_login_required'
		unless filter_chain.select(&:before?).map(&:identifier
			).include?(identifier)
			before_filter :login_required,
				:identifier => identifier
		end
		inherited_without_ccls_calnet_before_filter(base)
	end

end

module InstanceMethods

	def logged_in?
		!current_user.nil?
	end

	#	Force the user to be have an SSO session open.
	def current_user_required
		# Have to add ".filter(self)" when not in before_filter line.
		CASClient::Frameworks::Rails::Filter.filter(self)
	end
	alias_method :login_required, :current_user_required

	def current_user
		@current_user ||= if( session && session[:calnetuid] )
				#	if the user model hasn't been loaded yet
				#	this will return nil and fail.
				User.find_create_and_update_by_uid(session[:calnetuid])
			else
				nil
			end
	end

	# This will allow the user to view the page without authentication
	# but will process CAS authentication data if the user already
	# has an SSO session open.  This is potentially useful if you
	#	don't store a copy of the user info locally.  Otherwise,
	#	not so much.
#
#	Not using, so commented out so not to affect code coverage output.
#
#	def cas_gateway_filter
#		# Have to add ".filter(self)" when not in before_filter line.
#		CASClient::Frameworks::Rails::GatewayFilter.filter(self)
#		@login_url = CASClient::Frameworks::Rails::Filter.login_url(self)
#	end

end	#	InstanceMethods

end	#	Ccls::Controller
ActionController::Base.send(:include,Ccls::Controller)
