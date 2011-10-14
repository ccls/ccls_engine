class FollowUp < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :section
	belongs_to :enrollment
	belongs_to :follow_up_type

# TODO change completed_by_uid to use the user's calnet :uid
#	TODO add virtual attribute :current_user to accept user from controller
#	attr_accessor :current_user

end
