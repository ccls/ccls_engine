class CreateDataSources < SharedMigration
	def self.up
		create_table :data_sources do |t|
			t.integer :position
			t.string :data_origin
			t.string :code, :null => false
			t.string :description, :null => false
			t.integer :organization_id
			t.string  :other_organization
			t.integer :person_id
			t.string  :other_person
			t.timestamps
		end
		add_index  :data_sources, :code, :unique => true
	end

	def self.down
		drop_table :data_sources
	end
end
