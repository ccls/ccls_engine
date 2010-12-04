class CreateDataSources < SharedMigration
	def self.up
		create_table :data_sources do |t|
			t.integer :position
			t.string :research_origin
			t.string :data_origin
			t.timestamps
		end
	end

	def self.down
		drop_table :data_sources
	end
end
