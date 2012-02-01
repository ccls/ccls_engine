class CreateIcfMasterTrackerUpdates < SharedMigration
	def self.up
		create_table :icf_master_tracker_updates do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :icf_master_tracker_updates
	end
end
