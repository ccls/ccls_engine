#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectPii
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	#	TODO include maiden_name just in case is mother???
	def childs_names
		[first_name, middle_name, last_name ]
	end

	#	Returns string containing study_subject's first, middle and last initials
	def initials
		childs_names.delete_if(&:blank?).collect{|s|s.chars.first}.join()
	end

	#	Returns string containing study_subject's first, middle and last name
	#	Use delete_if(&:blank?) instead of compact, which only removes nils.
	def full_name
		fullname = childs_names.delete_if(&:blank?).join(' ')
		( fullname.blank? ) ? '[name not available]' : fullname
	end

	def fathers_names
		[father_first_name, father_middle_name, father_last_name ]
	end

	#	Returns string containing study_subject's father's first, middle and last name
	def fathers_name
		fathersname = fathers_names.delete_if(&:blank?).join(' ')
		( fathersname.blank? ) ? '[name not available]' : fathersname
	end

	def mothers_names
		[mother_first_name, mother_middle_name, mother_last_name ]
	end

	#	Returns string containing study_subject's mother's first, middle and last name
	#	TODO what? no maiden name?
	def mothers_name
		mothersname = mothers_names.delete_if(&:blank?).join(' ')
		( mothersname.blank? ) ? '[name not available]' : mothersname
	end

	def guardians_names
		[guardian_first_name, guardian_middle_name, guardian_last_name ]
	end

	#	Returns string containing study_subject's guardian's first, middle and last name
	def guardians_name
		guardiansname = guardians_names.delete_if(&:blank?).join(' ')
		( guardiansname.blank? ) ? '[name not available]' : guardiansname
	end

#
#	TODO I hate this.  It is revolting.  More?  Yes, please.
#
	#	I don't know if I still need this
	#	commented out 20101014
	#	uncommented 20101014
	def dob	#	overwrite default dob method for formatting
		#	added to_date to fix sqlite3 quirk which doesn't	(why am I using sqlite3?)  old comment?
		#	differentiate between times and dates.
		read_attribute(:dob).try(:to_s,:dob).try(:to_date)
	end

end	#	class_eval
end	#	included
end	#	StudySubjectPii
