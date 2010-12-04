class AddProjectOutcomeToEnrollments < SharedMigration
	def self.up
		add_column :enrollments, :project_outcome_id, :integer
		add_column :enrollments, :project_outcome_on, :date
	end

	def self.down
		remove_column :enrollments, :project_outcome_on
		remove_column :enrollments, :project_outcome_id
	end
end
