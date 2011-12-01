class CreateAliquots < SharedMigration
	def self.up
		create_table :aliquots do |t|
			t.integer :position
			t.references :owner
			t.references :sample
			t.references :unit
			t.references :aliquot_sample_format
			t.string :location
			t.string :mass
			t.string :external_aliquot_id
			t.string :external_aliquot_id_source
			t.timestamps
		end
		add_index :aliquots, :owner_id
		add_index :aliquots, :sample_id
		add_index :aliquots, :unit_id
		add_index :aliquots, :aliquot_sample_format_id
	end

	def self.down
		drop_table :aliquots
	end
end
