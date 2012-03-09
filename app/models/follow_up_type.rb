#	==	requires
#	*	key ( unique )
#	*	description ( > 3 chars )
class FollowUpType < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :follow_ups

	#	Returns description
	def to_s
		description
	end

end
