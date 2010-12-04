class CreatePiis < SharedMigration
	def self.up
		create_table :piis do |t|
			t.references :subject
			t.string :first_name
			t.string :middle_name
			t.string :last_name
			t.date :dob
			t.date :died_on
			t.string :state_id_no
			t.string :phone_primary
			t.string :phone_alternate
			t.string :phone_alternate_2
			t.string :phone_alternate_3
			t.string :mother_first_name
			t.string :mother_middle_name
			t.string :mother_maiden_name
			t.string :mother_last_name
			t.string :father_first_name
			t.string :father_middle_name
			t.string :father_last_name
			t.string :email
			t.timestamps
		end
		add_index :piis, :state_id_no, :unique => true
		add_index :piis, :email, :unique => true
		add_index :piis, :subject_id, :unique => true
	end

	def self.down
		drop_table :piis
	end
end
