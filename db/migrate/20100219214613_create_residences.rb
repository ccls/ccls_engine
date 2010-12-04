class CreateResidences < SharedMigration
	def self.up
		create_table :residences do |t|
			t.integer :position
			t.references :address
			t.date :moved_in_on
			t.date :moved_out_on
			t.boolean :current_residence
			t.boolean :residence_at_diagnosis
			t.timestamps
		end
		add_index :residences, :address_id, :unique => true
	end

	def self.down
		drop_table :residences
	end
end
