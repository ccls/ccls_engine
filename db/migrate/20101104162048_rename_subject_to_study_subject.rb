class RenameSubjectToStudySubject < SharedMigration
	def self.up
#		rename_table  :subjects,  :study_subjects

		[ :addressings, :analyses_subjects, :home_exposure_responses,
				:homex_outcomes, :identifiers, :patients, 
				:phone_numbers, :piis ].each do |t|
#				:phone_numbers, :piis, :response_sets ].each do |t|
			remove_index t, :subject_id
		end
		remove_index :enrollments, [:project_id, :subject_id]
#		remove_index :survey_invitations, [:survey_id, :subject_id]

		[ :addressings, :analyses_subjects, :enrollments, :gift_cards,
				:home_exposure_responses, :homex_outcomes, :identifiers,
				:patients, :phone_numbers, :piis, :samples ].each do |t|
#				:patients, :phone_numbers, :piis, :response_sets,
#				:samples, :survey_invitations ].each do |t|
			rename_column t, :subject_id, :study_subject_id
		end

		[ :addressings, :analyses_subjects, :phone_numbers ].each do |t|
#				:response_sets ].each do |t|
			add_index t, :study_subject_id
		end
		[:home_exposure_responses,:homex_outcomes,:identifiers,:patients,
				:piis].each do |t|
			add_index t, :study_subject_id, :unique => true
		end
		add_index :enrollments, [:project_id, :study_subject_id], :unique => true
#		add_index :survey_invitations, [:survey_id, :study_subject_id], :unique => true

#		rename_table  :analyses_subjects, :analyses_study_subjects
	end

	def self.down
#		rename_table  :analyses_study_subjects, :analyses_subjects

#		remove_index  :survey_invitations, [:survey_id, :study_subject_id]
		remove_index  :enrollments, [:project_id, :study_subject_id]
		[ :addressings, :analyses_subjects, :home_exposure_responses,
				:homex_outcomes, :identifiers, :patients, :phone_numbers,
				:piis ].each do |t|
#				:piis, :response_sets ].each do |t|
			remove_index  t, :study_subject_id
		end

		[ :addressings, :analyses_subjects, :enrollments, :gift_cards,
				:home_exposure_responses, :homex_outcomes, :identifiers,
				:patients, :phone_numbers, :piis, :samples ].each do |t|
#				:patients, :phone_numbers, :piis, :response_sets,
#				:samples, :survey_invitations ].each do |t|
			rename_column t, :study_subject_id, :subject_id
		end

		[ :analyses_subjects, :home_exposure_responses, :homex_outcomes,
				:identifiers, :patients, :piis ].each do |t|
			add_index     t, :subject_id, :unique => true
		end
#		add_index     :survey_invitations, [:survey_id, :subject_id], :unique => true
		add_index     :enrollments, [:project_id, :subject_id], :unique => true
#		[:addressings,:phone_numbers,:response_sets].each do |t|
		[:addressings,:phone_numbers].each do |t|
			add_index     t, :subject_id
		end

#		rename_table :study_subjects, :subjects
	end
end
