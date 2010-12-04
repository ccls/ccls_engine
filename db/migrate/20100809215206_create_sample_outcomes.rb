class CreateSampleOutcomes < SharedMigration
	def self.up
		create_table :sample_outcomes do |t|
			t.integer :position
			t.string :code, :null => false
			t.string :description
			t.timestamps
		end
		add_index :sample_outcomes, :code, :unique => true
	end

	def self.down
		drop_table :sample_outcomes
	end
end
