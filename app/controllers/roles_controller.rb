class RolesController < ApplicationController

	before_filter :may_assign_roles_required
	before_filter :user_id_required
	before_filter :may_not_be_user_required
	before_filter :id_required

	def update
		@user.roles << @role
		flash[:notice] = 'User was successfully updated.'
		redirect_to @user
	end

	def destroy
		@user.roles.delete @role
		flash[:notice] = 'User was successfully updated.'
		redirect_to @user
	end

protected

	def user_id_required
		if !params[:user_id].blank? and User.exists?(params[:user_id])
			@user = User.find(params[:user_id])
		else
			access_denied("user id required!", users_path)
		end
	end

	def id_required
		if !params[:id].blank? and Role.exists?(:name => params[:id])
			@role = Role.find_by_name(params[:id])
		else
			access_denied("id required!", @user)
		end
	end

end
