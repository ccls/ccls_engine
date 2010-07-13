module UcbCclsCmsHelper

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
