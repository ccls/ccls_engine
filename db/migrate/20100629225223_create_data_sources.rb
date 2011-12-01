class CreateDataSources < SharedMigration
	def self.up
		create_table :data_sources do |t|
			t.integer :position
			t.string :research_origin
			t.string :data_origin
			t.string :code, :null => false
			t.string :description, :null => false
			t.timestamps
		end
		add_index  :data_sources, :code, :unique => true
	end

	def self.down
		drop_table :data_sources
	end
end
