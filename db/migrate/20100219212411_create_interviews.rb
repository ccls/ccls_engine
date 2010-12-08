class CreateInterviews < SharedMigration
	def self.up
		create_table :interviews do |t|
			t.integer :position
			t.references :identifier
			t.references :address
			t.references :interviewer
			t.references :instrument_version
			t.references :interview_method
			t.references :language
			t.date :began_on
			t.date :ended_on
			t.string :respondent_first_name
			t.string :respondent_last_name
			t.integer :subject_relationship_id
			t.string :subject_relationship_other
			t.date  :intro_letter_sent_on
			t.timestamps
		end
	end

	def self.down
		drop_table :interviews
	end
end
