class DocumentVersion < Shared
	acts_as_list
	default_scope :order => :position
	belongs_to :document_type
	has_many :enrollments

	validates_presence_of :document_type_id
	validates_presence_of :document_type
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :title
		o.validates_length_of :description
		o.validates_length_of :indicator
	end

	#	Return title
	def to_s
		title
	end

	named_scope :type1, :conditions => { :document_type_id => 1 }

end
