module Ccls::ActionViewExtension::Base

	def self.included(base)
		base.send(:include, InstanceMethods)
	end

	module InstanceMethods

		def yndk(value=nil)
			YNDK[value]||'&nbsp;'
		end

		def ynodk(value=nil)
			YNODK[value]||'&nbsp;'
		end

		def ynrdk(value=nil)
			YNRDK[value]||'&nbsp;'
		end

		def adna(value=nil)
			ADNA[value]||'&nbsp;'
		end

		def _wrapped_yndk_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => (YNDK[object.send(method)]||'&nbsp;') ) )
		end

		def _wrapped_ynodk_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => (YNODK[object.send(method)]||'&nbsp;') ) )
		end

		def _wrapped_ynrdk_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => (YNRDK[object.send(method)]||'&nbsp;') ) )
		end

		def _wrapped_adna_spans(object_name,method,options={})
			object = instance_variable_get("@#{object_name}")
			_wrapped_spans(object_name,method,options.update(
				:value => (ADNA[object.send(method)]||'&nbsp;') ) )
		end

	end	#	module InstanceMethods

end	#	module Ccls::ActionViewExtension::Base
ActionView::Base.send(:include, 
	Ccls::ActionViewExtension::Base )
