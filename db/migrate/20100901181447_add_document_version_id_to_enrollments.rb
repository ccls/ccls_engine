class AddDocumentVersionIdToEnrollments < SharedMigration
	def self.up
		add_column :enrollments, :document_version_id, :integer
	end

	def self.down
		remove_column :enrollments, :document_version_id
	end
end
