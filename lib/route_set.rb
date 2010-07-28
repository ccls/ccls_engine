#	class ActionController::Routing::RouteSet
#		def load_routes_with_engine!
#			engine_routes = File.expand_path(
#				File.join(File.dirname(__FILE__),
#					*%w[.. config engine_routes.rb]))
#			unless configuration_files.include? engine_routes
#				add_configuration_file(engine_routes)
#			end
#		load_routes_without_engine!
#		end
#		alias_method_chain :load_routes!, :engine
#	end
#
#	This is no longer used or needed.
#
