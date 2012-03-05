class CreateInstrumentTypes < SharedMigration
	def self.up
		create_table :instrument_types do |t|
			t.integer :position
			t.references :project
			t.string :key, :null => false
#			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :instrument_types, :key, :unique => true
#		add_index :instrument_types, :code, :unique => true
		add_index :instrument_types, :description, :unique => true
	end

	def self.down
		drop_table :instrument_types
	end
end
