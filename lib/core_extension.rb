module CoreExtension

	def class_exists?(class_name)
		klass = Module.const_get(class_name.to_s)
		return klass.is_a?(Class)
	rescue NameError
		return false
	end

end
include CoreExtension
