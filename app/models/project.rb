#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Project < Shared
	acts_as_list
	default_scope :order => :position

	has_and_belongs_to_many :samples
#	has_many :operational_event_types
	has_many :instrument_types
	has_many :enrollments
	has_many :gift_cards
	has_many :subjects, :through => :enrollments, :foreign_key => 'study_subject_id'
	has_many :instruments

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code,        :maximum => 250
	validates_length_of     :description, :in => 4..250

	validates_complete_date_for :began_on, :allow_nil => true
	validates_complete_date_for :ended_on, :allow_nil => true


#	TODO perhaps move this into subject where is clearly belongs
	#	Returns all projects for which the subject
	#	does not have an enrollment
	def self.unenrolled_projects(subject)
		Project.all(
			:joins => "LEFT JOIN enrollments ON " <<
				"projects.id = enrollments.project_id AND " <<
				"enrollments.study_subject_id = #{subject.id}",
			:conditions => [ "enrollments.study_subject_id IS NULL" ])
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

	#	Returns description
	def to_s
		description
	end

end
