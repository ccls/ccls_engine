#	==	requires
#	*	description (unique and >3 chars)
class Context < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :units
#	has_many :people

	has_many :context_data_sources
	has_many :data_sources, :through => :context_data_sources

	#	Returns description
	def to_s
		description
	end

end
