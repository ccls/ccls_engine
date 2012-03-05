#	==	requires
#	*	description ( unique and > 3 chars )
class Unit < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	belongs_to :context
	has_many :aliquots
	has_many :samples

end
