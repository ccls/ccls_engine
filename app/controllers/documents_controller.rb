class DocumentsController < ApplicationController

	before_filter :may_maintain_pages_required
	before_filter :id_required, 
		:only => [ :show, :edit, :update, :destroy, :preview ]

	def show
		if @document.document.path.blank?
			flash[:error] = "Does not contain a document"
			redirect_to @document
		elsif !File.exists?(@document.document.path)
			flash[:error] = "Document does not exist"
			redirect_to @document
		else
			send_file @document.document.path
		end
	end

	def preview
#		#	otherwise looks for template for pdf, jpg or whatever
#		params[:format] = 'html'
	end

	def index
		@documents = Document.all
	end

	def new
		@document = Document.new
	end

	def create
		@document = Document.new(params[:document])
		@document.save!
		redirect_to @document
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Error"
		render :action => 'new'
	end

	def update
		@document.update_attributes!(params[:document])
		redirect_to @document
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Error"
		render :action => 'edit'
	end

	def destroy
		@document.destroy
		redirect_to documents_path
	end

protected

	def id_required
		if !params[:id].blank? and Document.exists?(params[:id])
			@document = Document.find(params[:id])
		elsif !params[:id].blank? and Document.exists?(
			:document_file_name => "#{params[:id]}.#{params[:format]}")
			documents = Document.find(:all, :conditions => {
			:document_file_name => "#{params[:id]}.#{params[:format]}"})
			if documents.length > 1
				access_denied("More than one document matches #{params[:id]}!", 
					documents_path)
			else
				@document=documents[0]
			end
		else
			access_denied("Valid document id required!", documents_path)
		end
	end

end
