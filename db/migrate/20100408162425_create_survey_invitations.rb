class CreateSurveyInvitations < SharedMigration
	def self.up
		create_table :survey_invitations do |t|
			t.references :subject, :null => false
			t.references :response_set
			t.references :survey
			t.string :token, :null => false
			t.datetime :sent_at
			t.timestamps
		end
		add_index :survey_invitations, :token, :unique => true
		add_index :survey_invitations, [:survey_id, :subject_id], :unique => true
	end

	def self.down
		drop_table :survey_invitations
	end
end
