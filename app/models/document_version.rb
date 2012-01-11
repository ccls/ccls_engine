class DocumentVersion < ActiveRecordShared

	acts_as_list
	default_scope :order => :position
	belongs_to :document_type
	belongs_to :language
	has_many :enrollments

	validates_presence_of :document_type_id
	validates_presence_of :document_type, :if => :document_type_id

	validates_length_of   :title,       :maximum => 250, :allow_blank => true
	validates_length_of   :description, :maximum => 250, :allow_blank => true
	validates_length_of   :indicator,   :maximum => 250, :allow_blank => true

	validates_complete_date_for :began_use_on, :allow_nil => true
	validates_complete_date_for :ended_use_on, :allow_nil => true

	#	Return title
	def to_s
		title
	end

	named_scope :type1, :conditions => { :document_type_id => 1 }

end
