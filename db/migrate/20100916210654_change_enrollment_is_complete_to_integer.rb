class ChangeEnrollmentIsCompleteToInteger < SharedMigration
	def self.up
		change_column :enrollments, :is_complete, :integer
	end

	def self.down
		change_column :enrollments, :is_complete, :boolean
	end
end
