class ModifyAddresses2 < SharedMigration
	def self.up
		change_table :addresses do |t|
			t.remove_index :subject_id
			t.remove_index :address_id
			t.remove :position
			t.remove :subject_id
#			t.remove :address_id
			t.remove :is_valid
			t.remove :why_invalid
			t.remove :is_verified
			t.remove :how_verified
			t.remove :current_address
			t.remove :address_at_diagnosis
			t.remove :verified_on
			t.remove :verified_by_id

#			t.references :addressable, :polymorphic => true
		end
	end

	def self.down
		change_table :addresses do |t|
#			t.remove :addressable_id
#			t.remove :addressable_type

			t.integer    :position
			t.references :subject
#			t.references :address
			t.boolean    :is_valid
			t.string     :why_invalid
			t.boolean    :is_verified
			t.string     :how_verified
			t.integer    :current_address
			t.integer    :address_at_diagnosis
			t.datetime   :verified_on
			t.integer    :verified_by_id
			t.index      :subject_id
			t.index      :address_id
		end
	end
end
