class CreateHospitals < SharedMigration
	def self.up
		create_table :hospitals do |t|
			t.integer :position
			t.integer :organization_id
			t.boolean :has_irb_waiver, :null => false, :default => false
			t.timestamps
		end
		add_index :hospitals, :organization_id
	end

	def self.down
		drop_table :hospitals
	end
end
