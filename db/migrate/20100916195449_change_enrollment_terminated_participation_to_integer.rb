class ChangeEnrollmentTerminatedParticipationToInteger < SharedMigration
	def self.up
		change_column :enrollments, :terminated_participation, :integer
	end

	def self.down
		change_column :enrollments, :terminated_participation, :boolean
	end
end
