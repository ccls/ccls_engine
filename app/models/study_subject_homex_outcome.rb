#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectHomexOutcome
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	has_one :homex_outcome

	delegate :interview_outcome, :interview_outcome_on,
		:sample_outcome, :sample_outcome_on,
			:to => :homex_outcome, :allow_nil => true

	accepts_nested_attributes_for :homex_outcome

end	#	class_eval
end	#	included
end	#	StudySubjectHomexOutcome
