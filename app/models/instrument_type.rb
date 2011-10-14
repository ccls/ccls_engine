#	==	requires
#	*	description ( unique and > 3 chars )
#	*	project
class InstrumentType < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position

	belongs_to :project
	has_many :instrument_versions

	validates_presence_of   :project_id
	validates_presence_of   :project
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end

end
