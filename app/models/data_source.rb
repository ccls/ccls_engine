# don't know exactly
class DataSource < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position
	has_many :addresses

	validates_length_of :research_origin, :data_origin,
		:maximum => 250, :allow_blank => true
end
