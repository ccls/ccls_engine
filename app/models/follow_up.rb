class FollowUp < Shared
	belongs_to :section
	belongs_to :enrollment
	belongs_to :follow_up_type
end