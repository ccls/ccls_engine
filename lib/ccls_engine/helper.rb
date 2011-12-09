module Ccls::Helper

	def sort_up_image
		"#{Rails.root}/public/images/sort_up.png"
	end

	def sort_down_image
		"#{Rails.root}/public/images/sort_down.png"
	end

	#	&uarr; and &darr;
	def sort_link(column,text=nil)
		#	make local copy so mods to muck up real params which
		#	may still be references elsewhere.
		local_params = params.dup

#
#	May want to NOT flip dir for other columns.  Only the current order.
#	Will wait until someone else makes the suggestion.
#
		order = column.to_s.downcase.gsub(/\s+/,'_')
		dir = ( local_params[:dir] && local_params[:dir] == 'asc' ) ? 'desc' : 'asc'

		local_params[:page] = nil
		link_text = text||column
		classes = ['sortable',order]
		arrow = ''
		if local_params[:order] && local_params[:order] == order
			classes.push('sorted')
			arrow = if dir == 'desc'
				if File.exists? sort_down_image
					image_tag( File.basename(sort_down_image), :class => 'down arrow')
				else
					"<span class='down arrow'>&darr;</span>"
				end
			else
				if File.exists? sort_up_image
					image_tag( File.basename(sort_up_image), :class => 'up arrow')
				else
					"<span class='up arrow'>&uarr;</span>"
				end
			end
		end
		s = "<div class='#{classes.join(' ')}'>"
		s << link_to(link_text,local_params.merge(:order => order,:dir => dir))
		s << arrow unless arrow.blank?
		s << "</div>"
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

	#	Used to replace the _id_bar partial
	def subject_id_bar(study_subject,&block)
		stylesheets('study_subject_id_bar')
		content_for :main do
			"<div id='id_bar'>\n" <<
			"<div class='childid'>\n" <<
			"<span>ChildID:</span>\n" <<
			"<span>#{study_subject.try(:childid)}</span>\n" <<
			"</div><!-- class='childid' -->\n" <<
			"<div class='studyid'>\n" <<
			"<span>StudyID:</span>\n" <<
			"<span>#{study_subject.try(:studyid)}</span>\n" <<
			"</div><!-- class='studyid' -->\n" <<
			"<div class='full_name'>\n" <<
			"<span>#{study_subject.full_name}</span>\n" <<
			"</div><!-- class='full_name' -->\n" <<
			"<div class='controls'>\n" <<
			@content_for_id_bar.to_s <<
			((block_given?)?yield: '') <<
			"</div><!-- class='controls' -->\n" <<
			"</div><!-- id='id_bar' -->\n"
		end

		content_for :main do
			"<div id='do_not_contact'>\n" <<
			"Study Subject requests no further contact with Study.\n" <<
			"</div>\n" 
		end if study_subject.try(:do_not_contact?)
	end	#	id_bar_for
	alias_method :study_subject_id_bar, :subject_id_bar

	#	Just a simple method to wrap the passed text in a span
	#	with class='required'
	def required(text)
		"<span class='required'>#{text}</span>"
	end
	alias_method :req, :required

end
ActionView::Base.send(:include, Ccls::Helper)
