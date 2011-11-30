#	==	requires
#	*	description ( unique and > 3 chars )
class Unit < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	belongs_to :context
	has_many :aliquots
	has_many :samples

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_presence_of   :description
	validates_uniqueness_of :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true

end
