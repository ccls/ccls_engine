#	==	requires
#	*	description (unique and >3 chars)
class Context < Shared
	acts_as_list
	default_scope :order => :position

	has_many :units
#	has_many :people

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end
end
