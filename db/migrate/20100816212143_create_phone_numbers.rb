class CreatePhoneNumbers < SharedMigration
	def self.up
		create_table :phone_numbers do |t|
			t.integer    :position
			t.references :subject
			t.references :phone_type
			t.integer    :data_source_id
			t.string     :phone_number
			t.boolean    :is_primary
			t.boolean    :is_valid
			t.string     :why_invalid
			t.boolean    :is_verified
			t.string     :how_verified
			t.datetime   :verified_on
			t.integer    :verified_by_id
			t.timestamps
		end
		add_index :phone_numbers, :subject_id
	end

	def self.down
		drop_table :phone_numbers
	end
end
