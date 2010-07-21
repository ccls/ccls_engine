class SessionsController < ApplicationController

#	skip_before_filter :login_required, :only => :create
#
#	def create
#		CASClient::Frameworks::Rails::Filter.config[
#			:service_url] = request.env["HTTP_REFERER"]
#		CASClient::Frameworks::Rails::Filter.filter(self)
#		unless performed?
#		CASClient::Frameworks::Rails::Filter.config[:service_url] = nil
#		redirect_to( session[:refer_to] || root_path ) 
#		session[:refer_to] = nil
#		end
#	end

	def destroy
		calnetuid = session[:calnetuid]
		reset_session
		CASClient::Frameworks::Rails::Filter.logout(self)
	end

end
