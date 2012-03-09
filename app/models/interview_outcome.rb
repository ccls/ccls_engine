# don't know exactly
class InterviewOutcome < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :homex_outcomes

	#	Returns description
	def to_s
		description
	end

end
