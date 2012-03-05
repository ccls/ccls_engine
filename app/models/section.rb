#	==	requires
#	*	key ( unique )
#	*	description ( > 3 chars )
class Section < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :follow_ups

	#	Returns description
	def to_s
		description
	end

end
