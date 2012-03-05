#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectInterviews
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	has_many :interviews

	#	Returns home exposures interview
	def hx_interview
		interviews.find(:first,
#			:conditions => "projects.key = 'HomeExposures'",
			:conditions => { 'projects.id' => Project['HomeExposures'].id },
			:joins => [:instrument_version => [:instrument => :project]]
		)
	end

end	#	class_eval
end	#	included
end	#	StudySubjectInterviews
