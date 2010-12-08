class CreateAddresses < SharedMigration
	def self.up
		create_table :addresses do |t|
#			t.integer :position
#			t.references :subject
			t.references :address_type
			t.references :data_source
			t.string :line_1
			t.string :line_2
			t.string :city
			t.string :state
			t.string :zip
			t.integer :external_address_id

#			t.boolean  :is_valid
#			t.string   :why_invalid
#			t.boolean  :is_verified
#			t.string   :how_verified
#			t.integer  :current_address
#			t.integer  :address_at_diagnosis
#			t.datetime :verified_on				#	datetime of is_verified change 
#			t.integer  :verified_by_id		#	joins users table at users_id

			t.timestamps
		end
#		add_index :addresses, :subject_id
	end

	def self.down
		drop_table :addresses
	end
end
