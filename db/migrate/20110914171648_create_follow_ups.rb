class CreateFollowUps < SharedMigration
	def self.up
		create_table :follow_ups do |t|
			t.integer :section_id, :null => false
			t.integer :enrollment_id, :null => false
			t.integer :follow_up_type_id, :null => false
			t.date :completed_on
			t.string :completed_by_uid
			t.timestamps
		end
	end

	def self.down
		drop_table :follow_ups
	end
end
