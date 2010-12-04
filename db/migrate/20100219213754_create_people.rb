class CreatePeople < SharedMigration
	def self.up
		create_table :people do |t|
			t.integer :position
			t.references :context
			t.string :first_name
			t.string :last_name
			t.timestamps
		end
	end

	def self.down
		drop_table :people
	end
end
