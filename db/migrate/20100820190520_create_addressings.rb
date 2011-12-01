class CreateAddressings < SharedMigration
	def self.up
		create_table :addressings do |t|
			t.references :study_subject
			t.references :address
			t.integer    :current_address, :default => 1
			t.integer    :address_at_diagnosis
			t.date       :valid_from
			t.date       :valid_to
			t.integer    :is_valid
			t.string     :why_invalid
			t.boolean    :is_verified
			t.string     :how_verified
			t.datetime   :verified_on
			t.string     :verified_by_uid
			t.integer    :data_source_id
			t.string     :data_source_other
			t.timestamps
		end
		add_index :addressings, :study_subject_id
		add_index :addressings, :address_id
	end

	def self.down
		drop_table :addressings
	end
end
