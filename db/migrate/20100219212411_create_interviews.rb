class CreateInterviews < SharedMigration
	def self.up
		create_table :interviews do |t|
			t.integer :position
			t.integer :study_subject_id
			t.integer :address_id
			t.integer :interviewer_id
			t.integer :instrument_version_id
			t.integer :interview_method_id
			t.integer :language_id
			t.date    :began_on
			t.date    :ended_on
			t.string  :respondent_first_name
			t.string  :respondent_last_name
			t.integer :subject_relationship_id
			t.string  :subject_relationship_other
			t.date    :intro_letter_sent_on
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
