#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectLanguages
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	has_many :subject_languages
	has_many :languages, :through => :subject_languages

	accepts_nested_attributes_for :subject_languages, 
		:allow_destroy => true,
		:reject_if => proc{|attributes| attributes['language_id'].blank? }

end	#	class_eval
end	#	included
end	#	StudySubjectLanguages
