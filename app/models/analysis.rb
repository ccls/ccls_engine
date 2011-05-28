# don't know exactly
class Analysis < Shared
#
#	TODO remove the habtm and replace it with hmt SubjectAnalyses ?
#
	has_and_belongs_to_many :subjects, :association_foreign_key => 'study_subject_id'

#	TODO seriously?  remove the block as its more code that it replaces
	with_options :class_name => 'Person' do |o|
		o.belongs_to :analyst
		o.belongs_to :analytic_file_creator
	end
	belongs_to :project

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end
end
