# don't know exactly
class Analysis < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
#
#	TODO remove the habtm and replace it with hmt SubjectAnalyses ?
#
	has_and_belongs_to_many :study_subjects

	belongs_to :analyst, :class_name => 'Person'
	belongs_to :analytic_file_creator, :class_name => 'Person'
	belongs_to :project

	validates_presence_of   :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true
	validates_uniqueness_of :description

end
