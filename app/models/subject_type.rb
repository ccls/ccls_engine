#	==	requires
#	*	description ( unique and > 3 chars )
class SubjectType < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :study_subjects

	#	Returns description
	def to_s
		description
	end

	#	Returns description
	def name
		description
	end

end
