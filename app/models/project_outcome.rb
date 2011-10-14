class ProjectOutcome < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position
	has_many :enrollments

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :description, :maximum => 250

	#	Returns description
	def to_s
		description
	end

end
