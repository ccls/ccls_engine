#	Due to some flexibility mods to CalnetAuthenticated
#	User doesn't load until it is needed, 
#	which means that calnet_authenticated isn't called,
#	which means that current_user doesn't know what 
#	a User is yet, which causes lots of ...
#	NoMethodError (undefined method `find_create_and_update_by_uid' for nil:NilClass):
#	so ...
unless Gem.source_index.find_name('ccls-ccls_engine').empty?
	gem 'ccls-ccls_engine'
	require '<%=class_name.underscore-%>' unless defined?(<%=class_name-%>)
end

#require 'user' unless defined?(User)
#if RAILS_ENV == 'development' &&
#	!Gem.source_index.find_name('ccls-ccls_engine').empty?
#if Gem.searcher.find('ccls_engine') && RAILS_ENV == 'development'
#require 'ccls_engine'	#	without this, rake has problems ...
#undefined local variable or method `ucb_authenticated' for #<Class:0x1059408d0>
#require '<%=class_name.underscore-%>' unless defined?(<%=class_name-%>)
#require 'role' unless defined?(Role)
#end
#	Actually, this is probably only needed in development,
#	but putting it in environments/development.rb doesn't
#	work right, even in an after_initialize.
