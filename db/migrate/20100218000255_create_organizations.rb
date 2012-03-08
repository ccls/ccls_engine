class CreateOrganizations < SharedMigration
	def self.up
		create_table :organizations do |t|
			t.integer :position
			t.string  :key,  :null => false
			t.string  :name
			t.integer :person_id
			t.timestamps
		end
		add_index :organizations, :key,  :unique => true
		add_index :organizations, :name, :unique => true
	end

	def self.down
		drop_table :organizations
	end
end
