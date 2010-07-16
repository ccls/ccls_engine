class PhotosController < ApplicationController

	before_filter :may_maintain_pages_required
	before_filter :id_required, :only => [ :show, :edit, :update, :destroy ]

	def index
		@photos = Photo.all
	end

	def new
		@photo = Photo.new
	end

	def create
		@photo = Photo.new(params[:photo])
		@photo.save!
		redirect_to @photo
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Error"
		render :action => 'new'
	end

	def update
		@photo.update_attributes!(params[:photo])
		redirect_to @photo
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Error"
		render :action => 'edit'
	end

	def destroy
		@photo.destroy
		redirect_to photos_path
	end

protected

	def id_required
		if !params[:id].blank? and Photo.exists?(params[:id])
			@photo = Photo.find(params[:id])
		else
			access_denied("Valid photo id required!", photos_path)
		end
	end

end
