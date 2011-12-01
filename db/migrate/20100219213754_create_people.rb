class CreatePeople < SharedMigration
	def self.up
		create_table :people do |t|
			t.integer :position
			t.string :first_name
			t.string :last_name
			t.string :honorific, :limit => 20
			t.integer :person_type_id
			t.timestamps
		end
	end

	def self.down
		drop_table :people
	end
end
