class FollowUp < ActiveRecordShared

#	with these null = false lines,
#	there should really be validations
#	or remove these.
#			t.integer :section_id, :null => false
#			t.integer :enrollment_id, :null => false
#			t.integer :follow_up_type_id, :null => false

	belongs_to :section
	belongs_to :enrollment
	belongs_to :follow_up_type

	attr_accessor :current_user

end
