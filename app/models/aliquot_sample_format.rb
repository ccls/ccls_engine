#	==	requires
#	*	description (unique and >3 chars)
class AliquotSampleFormat < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :aliquots
	has_many :samples

end
