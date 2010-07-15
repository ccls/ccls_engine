module Authorization

	module Controller
		def self.included(base)
			base.send(:include, InstanceMethods)
			base.alias_method_chain :method_missing, :authorization
		end

		module InstanceMethods

			def auth_redirections(permission_name)
				if respond_to?(:redirections) && 
					redirections.is_a?(Hash) &&
					!redirections[permission_name].blank?
					redirections[permission_name]
				else
					HashWithIndifferentAccess.new
				end
			end

			def method_missing_with_authorization(symb,*args, &block)
				method_name = symb.to_s
		
				if method_name =~ /^may_(not_)?(.+)_required$/
					full_permission_name = "#{$1}#{$2}"
					negate = !!$1		#	double bang converts to boolean
					permission_name = $2
					verb,target = permission_name.split(/_/,2)
		
					#	using target words where singular == plural won't work here
					if !target.blank? && target == target.singularize
						unless permission = current_user.try(
								"may_#{permission_name}?", 
								instance_variable_get("@#{target}") 
							)
							message = "You don't have permission to " <<
								"#{verb} this #{target}."
						end
					else
						#	current_user may be nil so must use try and NOT send
						unless permission = current_user.try("may_#{permission_name}?")
							message = "You don't have permission to " <<
								"#{permission_name.gsub(/_/,' ')}."
						end
					end

					#	exclusive or
					unless negate ^ permission
						#	if message is nil, negate will be true
						message ||= "Access denied.  May #{(negate)?'not ':''}" <<
							"#{permission_name.gsub(/_/,' ')}."
#						access_denied(message)
						ar = auth_redirections(full_permission_name)
						access_denied(
							(ar[:message]||message),
							(ar[:redirect_to]||"/")
						)
					end
				else
					method_missing_without_authorization(symb, *args, &block)
				end
			end

		end
	end

end
ActionController::Base.send(:include,Authorization::Controller)
