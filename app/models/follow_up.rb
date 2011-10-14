class FollowUp < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :section
	belongs_to :enrollment
	belongs_to :follow_up_type
end
