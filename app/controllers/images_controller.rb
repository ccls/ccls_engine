class ImagesController < ApplicationController

	skip_before_filter :login_required, :only => :show

	before_filter :may_maintain_pages_required, :except => :show
	before_filter :id_required, :only => [ :show, :edit, :update, :destroy ]

	ssl_allowed :show

	def index
		@images = Image.all
	end

	def new
		@image = Image.new
	end

	def create
		@image = Image.create!(params[:image])
		redirect_to @image
#	rescue
#		flash.now[:error] = "Error"
#		render :action => 'new'
	end

	def update
		@image.update_attributes!(params[:image])
		redirect_to @image
#	rescue
#		flash.now[:error] = "Error"
#		render :action => 'edit'
	end

	def destroy
		@image.destroy
		redirect_to images_path
	end

protected

	def id_required
		if !params[:id].blank? and Image.exists?(params[:id])
			@image = Image.find(params[:id])
		else
			access_denied("Valid image id required!", images_path)
		end
	end

end
