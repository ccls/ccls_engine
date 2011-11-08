class CreateContextDataSources < SharedMigration
	def self.up
		create_table :context_data_sources do |t|
			t.integer :context_id
			t.integer :data_source_id
			t.timestamps
		end
	end

	def self.down
		drop_table :context_data_sources
	end
end
