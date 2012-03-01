module Ccls::ActionViewExtension::FormBuilder

	def self.included(base)
		base.send(:include,InstanceMethods)
	end

	module InstanceMethods

#	NOTE 
#		calling <%= f.wrapped_yndk_select :code %> will NOT call these methods.
#		It will call the method missing and then the @template.method
#		Actually, now I believe that it will.
#

		def yndk_select(method,options={},html_options={})
			@template.select(object_name, method, YNDK.selector_options,
				{:include_blank => true}.merge(objectify_options(options)), html_options)
		end

		def ynrdk_select(method,options={},html_options={})
			@template.select(object_name, method, YNRDK.selector_options,
				{:include_blank => true}.merge(objectify_options(options)), html_options)
		end

		def ynodk_select(method,options={},html_options={})
			@template.select(object_name, method, YNODK.selector_options,
				{:include_blank => true}.merge(objectify_options(options)), html_options)
		end

		def adna_select(method,options={},html_options={})
			@template.select(object_name, method, ADNA.selector_options,
				{:include_blank => true}.merge(objectify_options(options)), html_options)
		end

	end	#	module InstanceMethods

end	#	module Ccls::ActionViewExtension::FormBuilder
ActionView::Helpers::FormBuilder.send(:include, 
	Ccls::ActionViewExtension::FormBuilder )
