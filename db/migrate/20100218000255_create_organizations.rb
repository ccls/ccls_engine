class CreateOrganizations < SharedMigration
	def self.up
		create_table :organizations do |t|
			t.integer :position
			t.string :key,  :null => false
#			t.string :code, :null => false, :limit => 15
			t.string :name
			t.integer :person_id
			t.timestamps
		end
		add_index :organizations, :key,  :unique => true
#		add_index :organizations, :code, :unique => true
		add_index :organizations, :name, :unique => true
	end

	def self.down
		drop_table :organizations
	end
end
