#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Language < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :interviews
	has_many :instrument_versions

	validates_presence_of   :code
	validates_uniqueness_of :code

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
