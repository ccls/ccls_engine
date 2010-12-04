class ChangeEnrollmentIsChosenToInteger < SharedMigration
	def self.up
		change_column :enrollments, :is_chosen, :integer
	end

	def self.down
		change_column :enrollments, :is_chosen, :boolean
	end
end
