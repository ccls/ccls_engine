#	==	requires
#	*	key ( unique )
#	*	description ( unique and > 3 chars )
#	*	interview_type_id
class InstrumentVersion < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	belongs_to :language
	belongs_to :instrument_type
	belongs_to :instrument
	has_many :interviews

	validates_presence_of   :instrument_type_id
	validates_presence_of   :instrument_type, :if => :instrument_type_id

	validates_complete_date_for :began_use_on, :allow_nil => true
	validates_complete_date_for :ended_use_on, :allow_nil => true

	#	Returns description
	def to_s
		description
	end

end
