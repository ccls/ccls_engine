class SubjectRelationship < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

#	has_many :study_subjects

	#	Returns description
	def to_s
		description
	end

	#	Returns boolean of comparison
	#	true only if key == 'other'
	def is_other?
		key == 'other'
	end

end
