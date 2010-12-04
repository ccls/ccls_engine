class CreateInterviews < SharedMigration
	def self.up
		create_table :interviews do |t|
			t.integer :position
			t.references :identifier
			t.references :address
			t.references :interviewer
			t.references :interview_version
			t.references :interview_method
			t.references :language
			t.date :began_on
			t.date :ended_on
			t.string :respondent_first_name
			t.string :respondent_last_name
			t.integer :respondent_relationship_id
			t.string :respondent_relationship_other
			t.timestamps
		end
	end

	def self.down
		drop_table :interviews
	end
end
