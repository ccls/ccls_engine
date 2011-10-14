class DocumentType < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position
	has_many :document_versions
	validates_presence_of :title
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :title
		o.validates_length_of :description
	end

	def to_s
		title
	end

end
