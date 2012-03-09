class ProjectOutcome < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :enrollments

#	validates_presence_of   :code
#	validates_uniqueness_of :code
#	validates_length_of     :code, :maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

end
