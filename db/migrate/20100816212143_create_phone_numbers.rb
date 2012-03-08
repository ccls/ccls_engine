class CreatePhoneNumbers < SharedMigration
	def self.up
		create_table :phone_numbers do |t|
			t.integer  :position
			t.integer  :study_subject_id
			t.integer  :phone_type_id
			t.integer  :data_source_id
			t.string   :phone_number
			t.boolean  :is_primary
			t.integer  :is_valid
			t.string   :why_invalid
			t.boolean  :is_verified
			t.string   :how_verified
			t.datetime :verified_on
			t.string   :verified_by_uid
			t.integer  :current_phone, :default => 1
			t.string   :data_source_other
			t.timestamps
		end
		add_index :phone_numbers, :study_subject_id
	end

	def self.down
		drop_table :phone_numbers
	end
end
