class CreateHospitals < SharedMigration
	def self.up
		create_table :hospitals do |t|
			t.integer :position
			t.references :organization
			t.timestamps
		end
		add_index :hospitals, :organization_id
	end

	def self.down
		drop_table :hospitals
	end
end
