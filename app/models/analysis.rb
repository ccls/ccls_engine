# don't know exactly
class Analysis < ActiveRecordShared
#
#	TODO remove the habtm and replace it with hmt SubjectAnalyses ?
#
	has_and_belongs_to_many :study_subjects

	belongs_to :analyst, :class_name => 'Person'
	belongs_to :analytic_file_creator, :class_name => 'Person'
	belongs_to :project

	acts_like_a_hash

end
