class CreateIcfMasterTrackers < SharedMigration
	def self.up
		create_table :icf_master_trackers do |t|

			t.timestamps
		end
	end

	def self.down
		drop_table :icf_master_trackers
	end
end
