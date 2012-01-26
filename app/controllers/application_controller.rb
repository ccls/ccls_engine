class ApplicationController < ActionController::Base

#	As is allowed elsewhere, don't think that I can do this.
#	def ssl_allowed?
#		Rails.env == 'development'	#	only when mucking about in development mode
#	end

#	#	used in roles_controller
#	def may_not_be_user_required
#		current_user.may_not_be_user?(@user) || access_denied(
#			"You may not be this user to do this", user_path(current_user))
#	end

#	def redirections
#		@redirections ||= HashWithIndifferentAccess.new({
#			:not_be_user => {
#				:redirect_to => user_path(current_user)
#			}
#		})
#	end

end
