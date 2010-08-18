module Ccls
module UcbCclsEngineHelper

	def form_link_to( title, url, options={} )
		extra_tags = extra_tags_for_form(options)
		s =  "\n" <<
			"<form " <<
			"class='#{options.delete(:class)||'form_link_to'}' " <<
			"action='#{url}' " <<
			"method='#{options.delete('method')}'>\n" <<
			extra_tags << "\n" <<
			submit_tag(title, :name => nil ) << "\n" <<
			"</form>\n"
	end

	def destroy_link_to( title, url, options={} )
		form_link_to( title, url, options.merge(
			'method' => 'delete',
			:class => 'destroy_link_to'
		) )
	end

	def aws_image_tag(image,options={})
		#	in console @controller is nil
		protocol = @controller.try(:request).try(:protocol) || 'http://'
		host = 's3.amazonaws.com/'
		bucket = ( defined?(RAILS_APP_NAME) && RAILS_APP_NAME ) || 'ccls'
		src = "#{protocol}#{host}#{bucket}/images/#{image}"
		alt = options.delete(:alt) || options.delete('alt') || image
		tag('img',options.merge({:src => src, :alt => alt}))
	end

	#	This creates a button that looks like a submit button
	#	but is just a javascript controlled link.
	#	I don't like it.
	def button_link_to( title, url, options={} )
#		id = "id='#{options[:id]}'" unless options[:id].blank?
#		klass = if options[:class].blank?
#			"class='link'"
#		else
#			"class='#{options[:class]}'"
#		end
#		s =  "<button #{id} #{klass} type='button'>"
		classes = ['link']
		classes << options[:class]
		s =  "<button class='#{classes.flatten.join(' ')}' type='button'>"
		s << "<span class='href' style='display:none;'>"
		s << url_for(url)
		s << "</span>"
		s << title
		s << "</button>"
		s
	end

	def user_roles
		s = ''
		if current_user.may_administrate?
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
			unless @stylesheets.include?(stylesheet.to_s)
				@stylesheets.push(stylesheet.to_s)
				content_for(:head,stylesheet_link_tag(stylesheet.to_s))
			end
		end
	end

	def javascripts(*args)
		@javascripts ||= []
		args.each do |javascript|
			unless @javascripts.include?(javascript.to_s)
				@javascripts.push(javascript.to_s)
				content_for(:head,javascript_include_tag(javascript).to_s)
			end
		end
	end

end
end
ActionView::Base.send(:include, Ccls::UcbCclsEngineHelper)
#require 'action_controller/helpers'
#helper UcbCclsEngineHelper
