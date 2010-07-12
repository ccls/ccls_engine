class UserSessionsController < ApplicationController

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	skip_before_filter :login_required, :except => [:destroy]
#	before_filter :no_current_user_required, :only => [:new,:create]
#
#	def new
#		@user_session = UserSession.new
#	end
#
#	def create	
#		@user_session = UserSession.new(params[:user_session])	
#		if @user_session.save	
#			flash[:notice] = "Successfully logged in."	
#			redirect_to session[:aegis_return_to] || 
#				session[:return_to] || root_url	
#			session[:aegis_return_to] = nil
#			session[:return_to] = nil
#		else	
#			#	The save will add errors to the object if login
#			#	fails.  These errors will be shown on the login
#			#	page which is bad practice as it gives a would-be
#			#	hacker assistance in valid user names.
##	If I clear the errors, the brute force attack message
##	of too many failed login attempts will disappear.
##	Need to find a way to clear except ...
#			@user_session.errors.delete(:username)
#			@user_session.errors.delete(:password)
#			#	Remember any base error messages.
##			e = @user_session.errors.on(:base)
##			@user_session.errors.clear
##			@user_session.errors.add(:base, e) if e
#			flash.now[:error] = "Login Failed."
#			render :action => 'new'	
#		end	
#	end	
#
#	def destroy	
#		@user_session = UserSession.find	
#		@user_session.destroy	
#		flash[:notice] = "Successfully logged out."	
#		redirect_to root_url	
#	end	
#
#end
#
#class ActiveRecord::Errors
#	def delete(key)
#		@errors.delete(key.to_s)
#	end
end
