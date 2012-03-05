#	==	requires
#	*	description ( unique and > 3 chars )
#	*	project
class InstrumentType < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	belongs_to :project
	has_many :instrument_versions

	validates_presence_of   :project_id
	validates_presence_of   :project, :if => :project_id

end
