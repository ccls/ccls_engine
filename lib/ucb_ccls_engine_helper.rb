module UcbCclsEngineHelper

	def user_roles
		s = ''
		if current_user.administrator?
			s << "<ul>"
			@roles.each do |role|
				s << "<li>"
				if @user.role_names.include?(role.name)
					s << link_to( "Remove user role of '#{role.name}'", 
						user_role_path(@user,role.name),
						:method => :delete )
				else
					s << link_to( "Assign user role of '#{role.name}'", 
						user_role_path(@user,role.name),
						:method => :put )
				end
				s << "</li>\n"
			end
			s << "</ul>\n"
		end
		s
	end

	def flasher
		s = ''
		flash.each do |key, msg|
			s << content_tag( :p, msg, :id => key, :class => 'flash' )
			s << "\n"
		end
		s << "<noscript>\n"
		s << "<p id='noscript' class='flash'>"
		s << "Javascript is required for this site to be fully functional."
		s << "</p>\n"
		s << "</noscript>\n"
	end

	#	Created to stop multiple entries of same stylesheet
	def stylesheets(*args)
		@stylesheets ||= []
		args.each do |stylesheet|
			unless @stylesheets.include?(stylesheet)
				@stylesheets.push(stylesheet)
				content_for(:head,stylesheet_link_tag(stylesheet))
			end
		end
	end

	def javascripts(*args)
		@javascripts ||= []
		args.each do |javascript|
			unless @javascripts.include?(javascript)
				@javascripts.push(javascript)
				content_for(:head,javascript_include_tag(javascript))
			end
		end
	end

end
ActionView::Base.send(:include, UcbCclsEngineHelper)
#require 'action_controller/helpers'
#helper UcbCclsEngineHelper
