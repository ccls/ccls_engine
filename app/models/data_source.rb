# don't know exactly
class DataSource < Shared
	acts_as_list
	default_scope :order => :position
	has_many :addresses
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :research_origin
		o.validates_length_of :data_origin
	end
end
