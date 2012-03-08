class CreateInstrumentVersions < SharedMigration
	def self.up
		create_table :instrument_versions do |t|
			t.integer :position
			t.integer :instrument_type_id
			t.integer :language_id
			t.integer :instrument_id
			t.date    :began_use_on
			t.date    :ended_use_on
			t.string  :key, :null => false
			t.string  :description
			t.timestamps
		end
		add_index :instrument_versions, :key, :unique => true
		add_index :instrument_versions, :description, :unique => true
	end

	def self.down
		drop_table :instrument_versions
	end
end
