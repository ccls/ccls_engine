class CreateInstrumentVersions < SharedMigration
	def self.up
		create_table :instrument_versions do |t|
			t.integer :position
			t.references :instrument_type
			t.references :language
			t.date :began_use_on
			t.date :ended_use_on
			t.string :code, :null => false
			t.string :description
			t.integer :instrument_id
			t.timestamps
		end
		add_index :instrument_versions, :code, :unique => true
		add_index :instrument_versions, :description, :unique => true
	end

	def self.down
		drop_table :instrument_versions
	end
end
