class FollowUp < ActiveRecordShared

	belongs_to :section
	belongs_to :enrollment
	belongs_to :follow_up_type

	attr_accessor :current_user

end
