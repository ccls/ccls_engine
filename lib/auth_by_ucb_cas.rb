require 'casclient'
require 'casclient/frameworks/rails/filter'

module AuthBy	#:nodoc:
module UCB	#:nodoc:
#	I know.  Naming isn't conventional.  Sue me.
#	UCB::CAS looks more appropriate, since they are acronyms, than Ucbcas
#	Further info regarding UCB's CAS setup can be found at 
#	https://calnet.berkeley.edu/developers/developerResources/cas/CASAppSetup.html#firstLevelServers
module CAS

	#	Setup the CASClient and add the cas_filter before_filter
	#	to all application_controller requests.  This can be
	#	overridden or "skipped" in any controller, particularly
	#	those that are passive and will use the cas_gateway_filter
	#	instead.
	def self.included(base)
		base_server_url = ( RAILS_ENV == "production" ) ?  "https://auth.berkeley.edu" : "https://auth-test.berkeley.edu"

		CASClient::Frameworks::Rails::Filter.configure(
			:username_session_key => :calnetuid,
			:cas_base_url => "#{base_server_url}/cas/"
		)

	end

protected

	#	Force the user to be have an SSO session open.
	def current_user_required
		# Have to add ".filter(self)" when not in before_filter line.
		CASClient::Frameworks::Rails::Filter.filter(self)
	end
	alias_method :login_required, :current_user_required

	def current_user
		@current_user ||= if( session[:calnetuid] )
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

end
end
end
ActionController::Base.send(:include,AuthBy::UCB::CAS)
