class ChangeEnrollmentIsEligibleToInteger < SharedMigration
	def self.up
		change_column :enrollments, :is_eligible, :integer
	end

	def self.down
		change_column :enrollments, :is_eligible, :boolean
	end
end
