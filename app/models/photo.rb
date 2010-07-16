class Photo < ActiveRecord::Base

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

	has_attached_file :image, :styles => {
		:full   => "900",
		:large  => "800",
		:medium => "600",
		:small  => "150x50>"
	}	#, :url => url, :path => path

end
