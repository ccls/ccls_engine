class RenameRespondentRelationshipToSubjectRelationshipInInterview < SharedMigration
	def self.up
		rename_column :interviews,
			:respondent_relationship_id,
			:subject_relationship_id
		rename_column :interviews,
			:respondent_relationship_other,
			:subject_relationship_other
	end

	def self.down
		rename_column :interviews,
			:subject_relationship_id,
			:respondent_relationship_id
		rename_column :interviews,
			:subject_relationship_other,
			:respondent_relationship_other
	end
end
