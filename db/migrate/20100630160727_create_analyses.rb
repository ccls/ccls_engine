class CreateAnalyses < SharedMigration
	def self.up
		create_table :analyses do |t|
			t.integer :analyst_id
			t.integer :project_id
			t.string  :key, :null => false
			t.string  :description
			t.integer :analytic_file_creator_id
			t.date    :analytic_file_created_date
			t.date    :analytic_file_last_pulled_date
			t.string  :analytic_file_location
			t.string  :analytic_file_filename
			t.timestamps
		end
		add_index :analyses, :key, :unique => true
	end

	def self.down
		drop_table :analyses
	end
end
