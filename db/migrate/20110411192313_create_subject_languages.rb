class CreateSubjectLanguages < SharedMigration
	def self.up
		create_table :subject_languages do |t|
			t.integer :study_subject_id
			t.integer :language_id
			t.string  :other
			t.timestamps
		end
	end

	def self.down
		drop_table :subject_languages
	end
end
