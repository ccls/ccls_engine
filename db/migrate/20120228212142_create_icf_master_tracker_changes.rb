class CreateIcfMasterTrackerChanges < SharedMigration
	def self.up
		create_table :icf_master_tracker_changes do |t|
			t.string  :icf_master_id, :null => false
			t.date    :master_tracker_date
			t.boolean :new_tracker_record, :default => false, :null => false
			t.string  :modified_column
			t.string  :previous_value
			t.string  :new_value
			t.timestamps
		end
		add_index :icf_master_tracker_changes, :icf_master_id
	end

	def self.down
		drop_table :icf_master_tracker_changes
	end
end
