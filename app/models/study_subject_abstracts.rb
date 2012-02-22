#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectAbstracts
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

#	Hmm?  How to do this here?
#	class NotTwoAbstracts < StandardError; end

	has_many :abstracts
	has_one :first_abstract, :class_name => 'Abstract',
		:conditions => [
			"entry_1_by_uid IS NOT NULL AND " <<
			"entry_2_by_uid IS NULL AND " <<
			"merged_by_uid  IS NULL" ]
	has_one :second_abstract, :class_name => 'Abstract',
		:conditions => [
			"entry_2_by_uid IS NOT NULL AND " <<
			"merged_by_uid  IS NULL" ]
	has_one :merged_abstract, :class_name => 'Abstract',
		:conditions => [ "merged_by_uid IS NOT NULL" ]
	has_many :unmerged_abstracts, :class_name => 'Abstract',
		:conditions => [ "merged_by_uid IS NULL" ]

	def abstracts_the_same?
		raise StudySubject::NotTwoAbstracts unless abstracts_count == 2
		#	abstracts.inject(:is_the_same_as?) was nice
		#	but using inject is ruby >= 1.8.7
		return abstracts[0].is_the_same_as?(abstracts[1])
	end

	def abstract_diffs
		raise StudySubject::NotTwoAbstracts unless abstracts_count == 2
		#	abstracts.inject(:diff) was nice
		#	but using inject is ruby >= 1.8.7
		return abstracts[0].diff(abstracts[1])
	end

end	#	class_eval
end	#	included
end	#	StudySubjectAbstracts
__END__
