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

	def ssl_required?
		# Force https everywhere (that doesn't have ssl_allowed set)
		true
	end

	def redirect_to_referer_or_default(default)
		redirect_to( session[:refer_to] || 
			request.env["HTTP_REFERER"] || default )
		session[:refer_to] = nil
	end

end

require 'ssl_requirement'
require 'application_controller'

ApplicationController.send(:include,SslRequirement)

#	My ssl_required? overrides SslRequirement so MUST come AFTER!
ApplicationController.send(:include,UcbCclsEngineController)
