class PagesController < ApplicationController

	skip_before_filter :login_required, :only => :show

	before_filter :may_maintain_pages_required, :except => :show
	before_filter :id_required, :only => [ :edit, :update, :destroy ]

#	caches partials from layout as well, which is too much
#	caching still buggy
#	if do cache layout, contains user links
#	if don't cache layout, submenu goes missing
	caches_action :show	#, :layout => false
	cache_sweeper :page_sweeper, :only => [:create, :update, :order, :destroy]

	ssl_allowed :show

	def order
#		params[:pages].reverse.each { |id| Page.find(id).move_to_top }
#	this doesn't even check for parents or anything
#	making it faster, but potentially error prone.
		params[:pages].each_with_index { |id,index| 
			Page.find(id).update_attribute(:position, index+1 ) }
		redirect_to pages_path(:parent_id=>params[:parent_id])
	end

	def show
		if params[:path]
 			@page = Page.by_path("/#{params[:path].join('/')}")
			raise ActiveRecord::RecordNotFound if @page.nil?
		else
			@page = Page.find(params[:id])
		end
		@page_title = @page.title(session[:locale])
		if @page.is_home? && defined?(HomePagePic)
			@hpp = HomePagePic.random_active()
		end
	rescue ActiveRecord::RecordNotFound
		flash_message = "Page not found with "
		flash_message << (( params[:id].blank? ) ? "path '/#{params[:path].join('/')}'" : "ID #{params[:id]}")
		flash.now[:error] = flash_message
	end

	def index
		@page_title = "CCLS Pages"
		params[:parent_id] = nil if params[:parent_id].blank?
		@pages = Page.all(:conditions => { :parent_id => params[:parent_id] })
	end

	def new
		@page_title = "Create New CCLS Page"
		@page = Page.new(:parent_id => params[:parent_id])
	end

	def edit
		@page_title = "Edit CCLS Page #{@page.title(session[:locale])}"
	end

	def create
		@page = Page.new(params[:page])
		@page.save!
		flash[:notice] = 'Page was successfully created.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the page"
		render :action => "new"
	end

	def update
		@page.update_attributes!(params[:page])
		flash[:notice] = 'Page was successfully updated.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the page."
		render :action => "edit"
	end

	def destroy
		@page.destroy
		redirect_to(pages_path)
	end

protected

	def id_required
		if !params[:id].blank? and Page.exists?(params[:id])
			@page = Page.find(params[:id])
		else
			access_denied("Valid page id required!", pages_path)
		end
	end

end
