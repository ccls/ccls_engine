require 'ssl_requirement'
module Ccls
module UcbCclsEngineController

	def self.included(base)
		base.extend(ClassMethods)
		base.send(:include, SslRequirement)
		#	My ssl_required? overrides SslRequirement so MUST come AFTER!
		base.send(:include, InstanceMethods)
		base.class_eval do
			class << self
				alias_method_chain :inherited, :ccls_before_filters
			end
		end
	end

	module ClassMethods

	private

		def inherited_with_ccls_before_filters(base)
			identifier = 'ccls_ensure_proper_protocol'
			unless filter_chain.select(&:before?).map(&:identifier
				).include?(identifier)
				before_filter :ensure_proper_protocol,
					:identifier => identifier
			end
			identifier = 'ccls_build_menu_js'
			unless filter_chain.select(&:before?).map(&:identifier
				).include?(identifier)
				before_filter :build_menu_js,
					:identifier => identifier
			end
			inherited_without_ccls_before_filters(base)
		end

	end	#	ClassMethods

	module InstanceMethods

	protected

		def ssl_required?
			# Force https everywhere (that doesn't have ssl_allowed set)
			true
		end

		def redirect_to_referer_or_default(default)
			redirect_to( session[:refer_to] || 
				request.env["HTTP_REFERER"] || default )
			session[:refer_to] = nil
		end

		#	Flash error message and redirect
		def access_denied( 
				message="You don't have permission to complete that action.", 
				default=root_path )
			session[:return_to] = request.request_uri
			flash[:error] = message
			redirect_to default
		end

		#	The menu is on every page and this seems as the
		#	only way for me to force it into the application
		#	layout.
		def build_menu_js
			js = "" <<
				"if ( typeof(translatables) == 'undefined' ){\n" <<
				"	var translatables = [];\n" <<
				"}\n"
			Page.roots.each do |page|
				js << "" <<
					"tmp={tag:'#menu_#{dom_id(page)}',locales:{}};\n"
				%w( en es ).each do |locale|
					js << "tmp.locales['#{locale}']='#{page.menu(locale)}'\n"
				end
				js << "translatables.push(tmp);\n"
			end
			@template.content_for :head do
				@template.javascript_tag js
			end
		end

	end	#	InstanceMethods
end	#	UcbCclsEngineController
end	#	Ccls
ActionController::Base.send(:include,Ccls::UcbCclsEngineController)
