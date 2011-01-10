module ActiveRecordExtension::Errors
	def self.included(base)
		base.extend(ClassMethods)
	end
	module ClassMethods
		def delete(key)
			@errors.delete(key.to_s)
		end
	end
end
ActiveRecord::Errors.send(:include,ActiveRecordExtension::Errors)
