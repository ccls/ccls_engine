# don't know exactly
class SampleOutcome < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :homex_outcomes

	#	Returns description
	def to_s
		description
	end

end
