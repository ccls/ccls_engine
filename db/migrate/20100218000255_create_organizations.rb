class CreateOrganizations < SharedMigration
	def self.up
		create_table :organizations do |t|
			t.integer :position
			t.integer :aliquots_count, :default => 0
			t.string :code, :null => false
			t.string :name
			t.timestamps
		end
		add_index :organizations, :code, :unique => true
		add_index :organizations, :name, :unique => true
	end

	def self.down
		drop_table :organizations
	end
end
