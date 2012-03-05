# don't know exactly
class InterviewMethod < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :interviews
	has_many :instruments

	#	Returns description
	def to_s
		description
	end

end
