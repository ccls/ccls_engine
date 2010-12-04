class ChangeEnrollmentIsCandidateToInteger < SharedMigration
	def self.up
		change_column :enrollments, :is_candidate, :integer
	end

	def self.down
		change_column :enrollments, :is_candidate, :boolean
	end
end
