class Instrument < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position

	belongs_to :project
	belongs_to :interview_method
	has_many :instrument_versions

	validates_presence_of   :project_id
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_presence_of   :name
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

	validates_complete_date_for :began_use_on, :allow_nil => true
	validates_complete_date_for :ended_use_on, :allow_nil => true
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :name
		o.validates_length_of :description
	end

	#	Return name
	def to_s
		name
	end

end
