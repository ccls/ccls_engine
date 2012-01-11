class AddUseOnDatesToDocumentVersions < SharedMigration
	def self.up
		add_column :document_versions, :language_id, :integer
		add_column :document_versions, :began_use_on, :date
		add_column :document_versions, :ended_use_on, :date
	end

	def self.down
		remove_column :document_versions, :ended_use_on
		remove_column :document_versions, :began_use_on
		remove_column :document_versions, :language_id
	end
end
