class AddFieldsToHomeExposureResponses < SharedMigration
	def self.up
		add_column :home_exposure_responses, :consent_read_over_phone, :boolean
		add_column :home_exposure_responses, :respondent_requested_new_consent, :boolean
		add_column :home_exposure_responses, :consent_reviewed_with_respondent, :boolean
	end

	def self.down
		remove_column :home_exposure_responses, :consent_reviewed_with_respondent
		remove_column :home_exposure_responses, :respondent_requested_new_consent
		remove_column :home_exposure_responses, :consent_read_over_phone
	end
end
