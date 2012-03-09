class Instrument < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	belongs_to :project
	belongs_to :interview_method
	has_many :instrument_versions

	validates_presence_of   :project_id
	validates_presence_of   :project, :if => :project_id

	validates_presence_of   :name
	validates_length_of     :name, :maximum => 250, :allow_blank => true

	validates_complete_date_for :began_use_on, :allow_nil => true
	validates_complete_date_for :ended_use_on, :allow_nil => true

	#	Return name
	def to_s
		name
	end

end
