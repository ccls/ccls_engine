class SessionsController < ApplicationController

	def destroy
		calnetuid = session[:calnetuid]
		CASClient::Frameworks::Rails::Filter.logout(self)
	end

end
