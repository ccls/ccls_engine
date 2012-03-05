class CreateLanguages < SharedMigration
	def self.up
		create_table :languages do |t|
			t.integer :position
			t.string :key, :null => false
			t.string :code, :null => false	#	actually holds a numeric value
			t.string :description
			t.timestamps
		end
		add_index :languages, :key,  :unique => true
		add_index :languages, :code, :unique => true
	end

	def self.down
		drop_table :languages
	end
end
