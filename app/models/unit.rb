#	==	requires
#	*	description ( unique and > 3 chars )
class Unit < Shared
	acts_as_list
	default_scope :order => :position

	belongs_to :context
	has_many :aliquots
	has_many :samples

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
	with_options :maximum => 250 do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end
end
