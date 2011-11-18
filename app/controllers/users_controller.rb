class UsersController < ApplicationController

	skip_before_filter :login_required, :only => :menu

	before_filter :id_required, :only => [:edit, :show, :update, :destroy]
	before_filter :may_view_user_required, :except => [:index,:menu]
	before_filter :may_view_users_required, :only => :index

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

end
