class Document < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'

	validates_presence_of :title
	validates_length_of :title, :minimum => 4

#	path = if Rails.env == 'production'
#		':rails_root.uploads/system/:attachment/:id/:style/:filename'
#	else
#		':rails_root/public/system/:attachment/:id/:style/:filename'
#	end
#
#	url = if Rails.env == 'production'
##		'http://ccls.berkeley.edu/ucb_sph_ccls.uploads/:attachment/:id/:style/:filename'
#		'/../ucb_sph_ccls.uploads/system/:attachment/:id/:style/:filename'
#	else
#		'/system/:attachment/:id/:style/:filename'
#	end

	#	documents/2/list_wireframe.pdf 
	path = ':rails_root/:attachment/:id/:filename'
#	url  = ':rails_root/:attachment/:id/:filename'

	has_attached_file :document, :path => path
end
