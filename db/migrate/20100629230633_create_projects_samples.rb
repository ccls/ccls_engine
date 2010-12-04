class CreateProjectsSamples < SharedMigration
	def self.up
		create_table :projects_samples, :id => false do |t|
			t.references :project
			t.references :sample
		end
		add_index :projects_samples, :project_id
		add_index :projects_samples, :sample_id
	end

	def self.down
		drop_table :projects_samples
	end
end
