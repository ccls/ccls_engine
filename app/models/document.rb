class Document < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
#	has_and_belongs_to_many :users
#	has_and_belongs_to_many :groups

	validates_presence_of :title
	validates_length_of :title, :minimum => 4

	validates_uniqueness_of :document_file_name, :allow_nil => true

	before_validation :nullify_blank_document_file_name

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
	path = if Rails.env == 'test'
		':rails_root/test/:attachment/:id/:filename'
	else
		':rails_root/:attachment/:id/:filename'
	end
#	url  = ':rails_root/:attachment/:id/:filename'

	has_attached_file :document, :path => path

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end
end
