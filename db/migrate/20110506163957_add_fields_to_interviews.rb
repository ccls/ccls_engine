class AddFieldsToInterviews < SharedMigration
	def self.up
		add_column :interviews, :consent_read_over_phone, :boolean
		add_column :interviews, :respondent_requested_new_consent, :boolean
		add_column :interviews, :consent_reviewed_with_respondent, :boolean
	end

	def self.down
		remove_column :interviews, :consent_reviewed_with_respondent
		remove_column :interviews, :respondent_requested_new_consent
		remove_column :interviews, :consent_read_over_phone
	end
end
