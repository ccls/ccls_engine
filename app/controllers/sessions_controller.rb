class SessionsController < ApplicationController

	def destroy
		calnetuid = session[:calnetuid]
		reset_session
		CASClient::Frameworks::Rails::Filter.logout(self)
	end

end
