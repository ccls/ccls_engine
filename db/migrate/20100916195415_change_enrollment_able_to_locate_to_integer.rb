class ChangeEnrollmentAbleToLocateToInteger < SharedMigration
	def self.up
		change_column :enrollments, :able_to_locate, :integer
	end

	def self.down
		change_column :enrollments, :able_to_locate, :boolean
	end
end
