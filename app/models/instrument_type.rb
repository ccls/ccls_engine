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

# validate on foreign key rather than association so error shows up correctly in view.
#	validates_presence_of   :project
	validates_presence_of   :project_id

	validates_presence_of   :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true
	validates_uniqueness_of :description

end
