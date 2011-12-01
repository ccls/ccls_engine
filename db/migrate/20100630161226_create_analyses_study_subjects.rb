class CreateAnalysesStudySubjects < SharedMigration
	def self.up
		create_table :analyses_study_subjects, :id => false do |t|
			t.references :analysis
			t.references :study_subject
		end
		add_index :analyses_study_subjects, :analysis_id
		add_index :analyses_study_subjects, :study_subject_id
	end

	def self.down
		drop_table :analyses_study_subjects
	end
end
