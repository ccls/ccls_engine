#	==	requires
#	*	description (unique and >3 chars)
class AliquotSampleFormat < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position

	has_many :aliquots
	has_many :samples

	validates_presence_of   :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true
	validates_uniqueness_of :description

end
