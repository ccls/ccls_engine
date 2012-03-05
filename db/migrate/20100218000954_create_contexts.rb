class CreateContexts < SharedMigration
	def self.up
		create_table :contexts do |t|
			t.integer :position
			t.string :key, :null => false
#			t.string :code, :null => false
			t.string :description
			t.text :notes
			t.timestamps
		end
		add_index :contexts, :key, :unique => true
#		add_index :contexts, :code, :unique => true
		add_index :contexts, :description, :unique => true
	end

	def self.down
		drop_table :contexts
	end
end
