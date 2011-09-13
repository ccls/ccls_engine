class SubjectRelationship < Shared
	acts_as_list
	default_scope :order => :position

#	has_many :study_subjects

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :maximum => 250
	validates_length_of     :description, :in => 4..250

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

	#	Returns boolean of comparison
	#	true only if code == 'other'
	def is_other?
		code == 'other'
	end

end
