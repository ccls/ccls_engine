#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
#	*	interview_type_id
class InstrumentVersion < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	belongs_to :language
	belongs_to :instrument_type
	belongs_to :instrument
	has_many :interviews

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_length_of     :description, :in => 4..250, :allow_blank => true

	validates_presence_of   :instrument_type_id
	validates_presence_of   :instrument_type, :if => :instrument_type_id

	validates_complete_date_for :began_use_on, :allow_nil => true
	validates_complete_date_for :ended_use_on, :allow_nil => true

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end
