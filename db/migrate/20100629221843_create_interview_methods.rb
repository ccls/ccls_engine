class CreateInterviewMethods < SharedMigration
	def self.up
		create_table :interview_methods do |t|
			t.integer :position
			t.string :key, :null => false
#			t.string :code, :null => false
			t.string :description	#, :null => false
			t.timestamps
		end
		add_index :interview_methods, :key, :unique => true
#		add_index :interview_methods, :code, :unique => true
#		add_index :interview_methods, :description, :unique => true
	end

	def self.down
		drop_table :interview_methods
	end
end
