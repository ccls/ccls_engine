#	==	requires
#	*	description ( unique and > 3 chars )
class Unit < Shared
	acts_as_list
	default_scope :order => :position

	belongs_to :context
	has_many :aliquots
	has_many :samples

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :maximum => 250
	validates_length_of     :description, :in => 4..250

end
