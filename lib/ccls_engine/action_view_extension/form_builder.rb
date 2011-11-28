module Ccls::ActionViewExtension::FormBuilder

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods
#ActionView::Helpers::FormBuilder.class_eval do

		def y_n_dk_select(method,options={},html_options={})
			@template.y_n_dk_select(
				@object_name, method, 
					objectify_options(options),
					html_options)
		end
		alias_method :yndk_select, :y_n_dk_select

		def a_d_na_select(method,options={},html_options={})
			@template.a_d_na_select(
				@object_name, method, 
					objectify_options(options),
					html_options)
		end
		alias_method :adna_select, :a_d_na_select

	end

end	#	module Ccls::ActionViewExtension::FormBuilder
ActionView::Helpers::FormBuilder.send(:include, Ccls::ActionViewExtension::FormBuilder )
