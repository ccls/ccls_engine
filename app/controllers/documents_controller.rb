class DocumentsController < ApplicationController

	before_filter :may_maintain_pages_required
	before_filter :document_required, :only => :show
	before_filter :id_required, 
		:only => [ :edit, :update, :destroy, :preview ]

	def show
		if @document.document.path.blank?
			flash[:error] = "Does not contain a document"
			redirect_to preview_document_path(@document)
		else
			if File.exists?(@document.document.path)
				#	basically development or non-s3 setup
				send_file @document.document.path
#			elsif( Net::HTTP.get_response(Document.s3_host,
#				@document.url_path).code.to_s == '200' )
			elsif @document.s3_public?
				#	basically a public s3 file
				redirect_to @document.document.url
#			elsif( Net::HTTP.get_response(Document.s3_host,
#				@document.s3_path).code.to_s == '200' )
			elsif @document.s3_private?


#	Privacy filters are still not active
				#	basically a private s3 file
				redirect_to @document.s3_url


			else
#				flash[:error] = "Document does not exist at #{@document.document.path}"

#puts "Tried and failed ..."
#puts "Document path: " + @document.document.path
#puts "S3 Host: " + Document.s3_host
#puts "Document url_path: " +@document.url_path
#puts "Public Response: " + Net::HTTP.get_response(Document.s3_host, @document.url_path).code.to_s 
#puts "Document s3_path: " + @document.s3_path
#puts "Private Response: " + Net::HTTP.get_response(Document.s3_host, @document.s3_path).code.to_s 
#puts "Document s3_url: " + @document.s3_url

				flash[:error] = "Document does not exist at the expected location."
				redirect_to preview_document_path(@document)
			end
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
		redirect_to preview_document_path(@document)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Error"
		render :action => 'new'
	end

	def update
		@document.update_attributes!(params[:document])
		redirect_to preview_document_path(@document)
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
		else
			access_denied("Valid document id required!", documents_path)
		end
	end

	def document_required
		if !params[:id].blank? and Document.exists?(params[:id])
			@document = Document.find(params[:id])
		elsif !params[:id].blank? and Document.exists?(
			:document_file_name => "#{params[:id]}.#{params[:format]}")
			documents = Document.find(:all, :conditions => {
			:document_file_name => "#{params[:id]}.#{params[:format]}"})
#	Due to the unique index, there can be only one!
#			if documents.length > 1
#				access_denied("More than one document matches #{params[:id]}!", 
#					documents_path)
#			else
				@document=documents[0]
#			end
		else
			access_denied("Valid document id required!", documents_path)
		end
	end

end
