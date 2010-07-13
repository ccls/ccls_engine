class LocalesController < ApplicationController

	skip_before_filter :login_required

	def show
		session[:locale] = params[:id]
		respond_to do |format|
			format.html { redirect_to_referer_or_default(root_path) }
			format.js { render :text => '' }
		end
	end

end
