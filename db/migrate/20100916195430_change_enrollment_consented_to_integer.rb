class ChangeEnrollmentConsentedToInteger < SharedMigration
	def self.up
		change_column :enrollments, :consented, :integer
	end

	def self.down
		change_column :enrollments, :consented, :boolean
	end
end
