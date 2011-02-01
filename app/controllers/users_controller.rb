class UsersController < ApplicationController

#ActionView::TemplateError (A copy of ApplicationHelper has been removed from the module tree but is still active!) on line #2 of app/views/layouts/_header.html.erb:
#	Adding 'unloadable' fixes the above, but I don't know what it
#	is actually doing.  I'll probably have to do this to the others.
#	'unloadable' means that its loaded only when needed
#	Referencing an unloaded model sometimes causes the above
#	so I just add "require" statements where needed.
#	I don't think that this is needed anymore.

#	unloadable

	skip_before_filter :login_required, :only => :menu
#	skip_before_filter :build_menu_js,  :only => :menu
#		:only => [:new, :create]

#	before_filter :no_current_user_required, :only => [:new, :create]
#	before_filter :valid_invitation_required, :only => [:new,:create]
	before_filter :id_required, :only => [:edit, :show, :update, :destroy]
	before_filter :may_view_user_required, :except => [:index,:menu]
	before_filter :may_view_users_required, :only => :index

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	def new	
#		@user = User.new	
#	end	
#
#	def create	
#		#	We want to create a user and invalidate the invitation.
#		#	NOT one or the other.  Must be both.
#		User.transaction do
#			@user = User.new(params[:user])	
#			@user.save!
#			@user_invitation.accepted_at = Time.now
#			@user_invitation.recipient_id = @user.id
#			@user_invitation.save!
#		end
#		flash[:notice] = "Registration successful."	
#		redirect_to login_url	
#	rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved
#		flash.now[:error] = 'User creation failed'
#		render :action => 'new'	
#	end	
#
#	def update	
#		@user.update_attributes!(params[:user])	
#		flash[:notice] = "Successfully updated profile."	
#		redirect_to root_url	
#	rescue ActiveRecord::RecordInvalid
#		flash.now[:error] = "Update failed"
#		render :action => 'edit'	
#	end 

	ssl_allowed :menu

	def menu
		respond_to do |format|
			format.js {}
		end
	end

	def show
		@roles = Role.all
	end

	def index
		@users = User.search(params)
#		flash[:error] = @errors if @errors
	end

	def destroy
		@user.destroy
		redirect_to users_path
	end

protected

	def id_required
		if !params[:id].blank? and User.exists?(params[:id])
			@user = User.find(params[:id])
		else
			access_denied("user id required!", users_path)
		end
	end

#	def valid_invitation_required
#		if !params[:token].blank? && UserInvitation.exists?(
#			:token => params[:token],
#			:recipient_id => nil)
#			@user_invitation = UserInvitation.find_by_token(params[:token])
#		else
#			access_denied("Valid UserInvitation token required!")
#		end
#	end

end
