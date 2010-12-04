class CreateAddressings < SharedMigration
	def self.up
		create_table :addressings do |t|
			t.references :subject
			t.references :address
			t.integer    :current_address
			t.integer    :address_at_diagnosis
			t.date       :valid_from
			t.date       :valid_to
			t.boolean    :is_valid
			t.string     :why_invalid
			t.boolean    :is_verified
			t.string     :how_verified
			t.datetime   :verified_on
			t.integer    :verified_by_id
			t.integer    :data_source_id
			t.timestamps
		end
		add_index :addressings, :subject_id
		add_index :addressings, :address_id
	end

	def self.down
		drop_table :addressings
	end
end
