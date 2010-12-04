class CreateIdentifiers < SharedMigration
	def self.up
		create_table :identifiers do |t|
			t.references :subject
			t.integer :childid
			t.integer :patid
			t.string  :case_control_type, :limit => 1
			t.integer :orderno
			t.string :lab_no
			t.string :related_childid
			t.string :related_case_childid
			t.string :ssn
			t.timestamps
		end
		add_index :identifiers, :ssn, :unique => true
		add_index :identifiers, [:patid,:case_control_type,:orderno],
			:unique => true,:name => 'piccton'
		add_index :identifiers, :subject_id, :unique => true
	end

	def self.down
		drop_table :identifiers
	end
end
