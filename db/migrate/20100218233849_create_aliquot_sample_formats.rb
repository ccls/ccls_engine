class CreateAliquotSampleFormats < SharedMigration
	def self.up
		create_table :aliquot_sample_formats do |t|
			t.integer :position
#			t.string :code, :null => false
			t.string :key, :null => false
			t.string :description
			t.timestamps
		end
		add_index :aliquot_sample_formats, :key, :unique => true
#		add_index :aliquot_sample_formats, :code, :unique => true
		add_index :aliquot_sample_formats, :description, :unique => true
	end

	def self.down
		drop_table :aliquot_sample_formats
	end
end
