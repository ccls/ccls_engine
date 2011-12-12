module Ccls::ActionViewExtension::Base

	def self.included(base)
		base.send(:include, InstanceMethods)
#		base.class_eval do
#			alias_method_chain( :method_missing, :wrapping 
#				) unless base.respond_to?(:method_missing_without_wrapping)
#		end
	end

	module InstanceMethods

#	TODO perhaps use the YNODK hash in these helpers
		def y_n_o_dk(value=nil)
			case value
				when 1   then 'Yes'
				when 2   then 'No'
				when 3   then 'Other'
				when 999 then "Don't Know"
				else '&nbsp;'
			end
		end
		alias_method :ynodk, :y_n_o_dk

		def _wrapped_y_n_o_dk_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => y_n_o_dk(object.send(method)) ) )
		end
		alias_method :_wrapped_ynodk_spans, :_wrapped_y_n_o_dk_spans

#		def y_n_o_dk_select(object_name, method, 
#				options={}, html_options={})
#			select(object_name, method,
#				[['Yes',1],['No',2],['Other',3],["Don't Know",999]],
#				{:include_blank => true}.merge(options), html_options)
#		end
#		alias_method :ynodk_select, :y_n_o_dk_select

#	TODO now that this is in ccls_engine, perhaps use the YNDK hash in these helpers
		def y_n_dk(value=nil)
			case value
				when 1   then 'Yes'
				when 2   then 'No'
				when 999 then "Don't Know"
				else '&nbsp;'
			end
		end
		alias_method :yndk, :y_n_dk

		def _wrapped_y_n_dk_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => y_n_dk(object.send(method)) ) )
		end
		alias_method :_wrapped_yndk_spans, :_wrapped_y_n_dk_spans

#		def y_n_dk_select(object_name, method, 
#				options={}, html_options={})
#			select(object_name, method,
#				[['Yes',1],['No',2],["Don't Know",999]],
#				{:include_blank => true}.merge(options), html_options)
#		end
#		alias_method :yndk_select, :y_n_dk_select

#	TODO perhaps add a ADNA hash in these helpers
		def a_d_na(value=nil)
			case value
				when 1   then 'Agree'
				when 2   then 'Do Not Agree'
				when 888 then "N/A"
				when 999 then "Don't Know"
				else '&nbsp;'
			end
		end
		alias_method :adna, :a_d_na

		def _wrapped_a_d_na_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => a_d_na(object.send(method)) ) )
		end
		alias_method :_wrapped_adna_spans, :_wrapped_a_d_na_spans

#		def a_d_na_select(object_name, method, 
#				options={}, html_options={})
#			select(object_name, method,
#				[['Agree',1],['Do Not Agree',2],['N/A',888],["Don't Know",999]],
#				{:include_blank => true}.merge(options), html_options)
#		end
#		alias_method :adna_select, :a_d_na_select

	end	#	module InstanceMethods

end	#	module Ccls::ActionViewExtension::Base
ActionView::Base.send(:include, 
	Ccls::ActionViewExtension::Base )
