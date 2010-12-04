class CreatePatients < SharedMigration
	def self.up
		create_table :patients do |t|
			t.references :subject
			t.date :diagnosis_date
			t.integer :hospital_no
			t.integer :diagnosis_id
			t.timestamps
		end
		add_index :patients, :subject_id, :unique => true
	end

	def self.down
		drop_table :patients
	end
end
