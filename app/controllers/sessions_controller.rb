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
#	done in CASClient ... logout
#		reset_session
#	if done above, will cause
#		NoMethodError (undefined method `destroy' for {}:Hash):
#		rubycas-client-2.2.1/lib/casclient/frameworks/rails/filter.rb:
#				183:in `send'
#		rubycas-client-2.2.1/lib/casclient/frameworks/rails/filter.rb:
#				183:in `logout'
#
# 179  def logout(controller, service = nil)
# 180    referer = service || controller.request.referer
# 181    st = controller.session[:cas_last_valid_ticket]
# 182    delete_service_session_lookup(st) if st
# 183    controller.send(:reset_session)
# 184    controller.send(:redirect_to, client.logout_url(referer))
# 185  end
#
#		This seems odd as you should be able to reset the
#		session anytime and as often as you'd like.
#
		CASClient::Frameworks::Rails::Filter.logout(self)
	end

end
