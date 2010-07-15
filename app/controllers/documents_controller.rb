class DocumentsController < ApplicationController

	before_filter :may_maintain_pages_required
	before_filter :id_required, :only => [ :show, :edit, :update, :destroy, :download ]

	def download
		if @document.document.path.blank?
			flash[:error] = "Does not contain a document"
			redirect_to @document
		else
			send_file @document.document.path
		end
	end

	def index
		@documents = Document.all
	end

	def new
		@document = Document.new
	end

	def create
		@document = Document.create!(params[:document])
		redirect_to @document
#	rescue
#		flash.now[:error] = "Error"
#		render :action => 'new'
	end

	def update
		@document.update_attributes!(params[:document])
		redirect_to @document
#	rescue
#		flash.now[:error] = "Error"
#		render :action => 'edit'
	end

	def destroy
		@document.destroy
		redirect_to documents_path
	end

protected

	def id_required
		if !params[:id].blank? and Document.exists?(params[:id])
			@document = Document.find(params[:id])
		else
			access_denied("Valid document id required!", documents_path)
		end
	end

end
