class CreateSections < SharedMigration
	def self.up
		create_table :sections do |t|
			t.integer :position
			t.string :key, :null => false
#			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :sections, :key, :unique => true
#		add_index :sections, :code, :unique => true
	end

	def self.down
		drop_table :sections
	end
end
