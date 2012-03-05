class CreateSubjectRelationships < SharedMigration
	def self.up
		create_table :subject_relationships do |t|
			t.integer :position
			t.string :key, :null => false
#			t.string :code, :null => false
			t.string :description, :null => false
			t.timestamps
		end
		add_index :subject_relationships, :key, :unique => true
#		add_index :subject_relationships, :code, :unique => true
		add_index :subject_relationships, :description, :unique => true
	end

	def self.down
		drop_table :subject_relationships
	end
end
