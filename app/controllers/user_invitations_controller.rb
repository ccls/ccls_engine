class UserInvitationsController < ApplicationController

#	We are using UCB CAS for authentication so this is unused.
#	If Authlogic or other is reused, uncomment all this.
#
#	before_filter :may_create_user_invitations_required,
#		:only => [ :new, :create ]
#	skip_before_filter :login_required, :only => :show
#	before_filter :no_current_user_required, :only => :show
#	before_filter :valid_id_required, :only => :show
#
#	def new
#		@user_invitation = UserInvitation.new
#	end
#
#	def create
#		@user_invitation = UserInvitation.new(params[:user_invitation])
#		@user_invitation.sender = current_user
#		@user_invitation.save!
#		flash[:notice] = "Invitation queued to send"
#		redirect_to root_path
#	rescue ActiveRecord::RecordInvalid
#		flash.now[:error] = "Invitation failed"
#		render :action => 'new'
#	end
#
#	def show
#		redirect_to new_user_path(:token => @user_invitation.token)
#	end
#
#protected
#
#	def valid_id_required
#		if !params[:id].blank? && UserInvitation.exists?(
#				:token => params[:id],
#				:recipient_id => nil)
#			@user_invitation = UserInvitation.find_by_token(params[:id])
#		else
#			access_denied("Valid UserInvitation token required!")
#		end
#	end

end
