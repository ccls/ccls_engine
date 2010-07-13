module UcbCclsAuthController

	def self.included(base)
#		base.extend(ClassMethods)
		base.send(:include, InstanceMethods)
		base.class_eval do

			before_filter :login_required

			# Scrub sensitive parameters from your log
			filter_parameter_logging :password

			helper_method :current_user, :logged_in?

		end
	end


	module InstanceMethods

	protected

		def logged_in?
			!current_user.nil?
		end

	end

end
#ActionController::Base.send(:include,UcbCclsAuthController)
ApplicationController.send(:include,UcbCclsAuthController)
