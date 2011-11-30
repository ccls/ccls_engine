class DocumentVersion < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position
	belongs_to :document_type
	has_many :enrollments

# validate on foreign key rather than association so error shows up correctly in view.
#	validates_presence_of :document_type
	validates_presence_of :document_type_id

	validates_length_of   :title,       :maximum => 250, :allow_blank => true
	validates_length_of   :description, :maximum => 250, :allow_blank => true
	validates_length_of   :indicator,   :maximum => 250, :allow_blank => true

	#	Return title
	def to_s
		title
	end

	named_scope :type1, :conditions => { :document_type_id => 1 }

end
