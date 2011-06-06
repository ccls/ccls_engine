# don't know exactly
class DataSource < Shared
	acts_as_list
	default_scope :order => :position
	has_many :addresses

	validates_length_of :research_origin, :data_origin,
		:maximum => 250, :allow_blank => true
end
