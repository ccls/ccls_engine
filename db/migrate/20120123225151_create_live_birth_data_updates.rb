class CreateLiveBirthDataUpdates < SharedMigration
	def self.up
		create_table :live_birth_data_updates do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :live_birth_data_updates
	end
end
