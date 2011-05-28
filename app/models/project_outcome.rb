class ProjectOutcome < Shared
	acts_as_list
	default_scope :order => :position
	has_many :enrollments

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_uniqueness_of :description

#	TODO compress this

	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end

	#	Returns description
	def to_s
		description
	end

end
