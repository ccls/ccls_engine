module UcbCclsEngineController

	def self.included(base)

		base.before_filter :login_required
		base.helper_method :current_user, :logged_in?

#		base.helper :ucb_ccls_engine_helper

	end

protected

	def logged_in?
		!current_user.nil?
	end

end
require 'application_controller'
ApplicationController.send(:include,UcbCclsEngineController)
