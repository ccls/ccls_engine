class CreateInterviews < SharedMigration
	def self.up
		create_table :interviews do |t|
			t.integer :position
			t.references :study_subject
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
			t.boolean :consent_read_over_phone
			t.boolean :respondent_requested_new_consent
			t.boolean :consent_reviewed_with_respondent
			t.datetime :began_at
			t.integer  :began_at_hour
			t.integer  :began_at_minute
			t.string   :began_at_meridiem
			t.datetime :ended_at
			t.integer  :ended_at_hour
			t.integer  :ended_at_minute
			t.string   :ended_at_meridiem
			t.timestamps
		end
		add_index :interviews, :study_subject_id
	end

	def self.down
		drop_table :interviews
	end
end
