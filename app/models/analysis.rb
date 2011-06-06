# don't know exactly
class Analysis < Shared
#
#	TODO remove the habtm and replace it with hmt SubjectAnalyses ?
#
	has_and_belongs_to_many :subjects, :association_foreign_key => 'study_subject_id'

	belongs_to :analyst, :class_name => 'Person'
	belongs_to :analytic_file_creator, :class_name => 'Person'
	belongs_to :project

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :maximum => 250
	validates_length_of     :description, :in => 4..250

end
