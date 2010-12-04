class CreateAnalysesSubjects < SharedMigration
	def self.up
		create_table :analyses_subjects, :id => false do |t|
			t.references :analysis
			t.references :subject
		end
		add_index :analyses_subjects, :analysis_id
		add_index :analyses_subjects, :subject_id
	end

	def self.down
		drop_table :analyses_subjects
	end
end
