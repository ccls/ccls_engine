class DocumentType < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position
	has_many :document_versions

	validates_presence_of :title
	validates_length_of   :title,       :maximum => 250, :allow_blank => true
	validates_length_of   :description, :maximum => 250, :allow_blank => true

	def to_s
		title
	end

end
