module AuthBy	#:nodoc:
module Authlogic

protected

	def current_user_session
		@current_user_session ||= UserSession.find	
	end	
	
	def current_user	
		@current_user ||= current_user_session && current_user_session.record	
	end	

	def current_user_required
		logged_in? ||
			access_denied("You must be logged in to do that",login_path)
	end
	alias_method :login_required, :current_user_required

end
end
ActionController::Base.send(:include,AuthBy::Authlogic)
