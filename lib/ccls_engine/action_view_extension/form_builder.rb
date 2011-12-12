module Ccls::ActionViewExtension::FormBuilder

	def self.included(base)
		base.send(:include,InstanceMethods)
	end

	module InstanceMethods

#	NOTE 
#		calling <%= f.wrapped_yndk_select :code %> will NOT call these methods.
#		It will call the method missing and then the @template.method
#

		def y_n_dk_select(method,options={},html_options={})
#			@template.y_n_dk_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				[['Yes',1],['No',2],["Don't Know",999]],
				{:include_blank => true}.merge(options), html_options)
		end
		alias_method :yndk_select, :y_n_dk_select

		def y_n_o_dk_select(method,options={},html_options={})
#			@template.y_n_o_dk_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				[['Yes',1],['No',2],['Other',3],["Don't Know",999]],
				{:include_blank => true}.merge(options), html_options)
		end
		alias_method :ynodk_select, :y_n_o_dk_select

		def a_d_na_select(method,options={},html_options={})
#			@template.a_d_na_select(
#				@object_name, method, 
#					objectify_options(options),
#					html_options)
			@template.select(object_name, method,
				[['Agree',1],['Do Not Agree',2],['N/A',888],["Don't Know",999]],
				{:include_blank => true}.merge(options), html_options)
		end
		alias_method :adna_select, :a_d_na_select

	end	#	module InstanceMethods

end	#	module Ccls::ActionViewExtension::FormBuilder
ActionView::Helpers::FormBuilder.send(:include, 
	Ccls::ActionViewExtension::FormBuilder )
