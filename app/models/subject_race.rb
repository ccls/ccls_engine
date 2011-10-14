class SubjectRace < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :race
end
