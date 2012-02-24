class AddRefusedByFieldsToEnrollments < SharedMigration
	def self.up
		add_column :enrollments, :refused_by_physician, :boolean
		add_column :enrollments, :refused_by_family, :boolean
	end

	def self.down
		remove_column :enrollments, :refused_by_family
		remove_column :enrollments, :refused_by_physician
	end
end
