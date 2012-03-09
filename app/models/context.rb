#	==	requires
#	*	description (unique and >3 chars)
class Context < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :units
#	has_many :people

	has_many :context_data_sources
	has_many :data_sources, :through => :context_data_sources

	validates_length_of :notes, :maximum => 65000, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

end
