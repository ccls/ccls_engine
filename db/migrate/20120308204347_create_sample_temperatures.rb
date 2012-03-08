class CreateSampleTemperatures < SharedMigration
	def self.up
		create_table :sample_temperatures do |t|
			t.integer :position
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :sample_temperatures, :key, :unique => true
	end

	def self.down
		drop_table :sample_temperatures
	end
end
