#module CclsEngine
module Ccls::CoreExtension

	def class_exists?(full_class_name)
		name_spaces = full_class_name.to_s.split('::')
		class_name = name_spaces.pop
		name_space = name_spaces.join('::')
		klass = ((name_space.blank?) ? Module : name_space.constantize).const_get(class_name.to_s)
		return klass.is_a?(Class)
	rescue NameError
		return false
	end

end	#	Ccls::CoreExtension
#include CclsEngine::CoreExtension
include Ccls::CoreExtension
