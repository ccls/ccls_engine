class AddAttachmentsCsvFileToLiveBirthDataUpdate < SharedMigration
	def self.up
		add_column :live_birth_data_updates, :csv_file_file_name, :string
		add_column :live_birth_data_updates, :csv_file_content_type, :string
		add_column :live_birth_data_updates, :csv_file_file_size, :integer
		add_column :live_birth_data_updates, :csv_file_updated_at, :datetime
	end

	def self.down
		remove_column :live_birth_data_updates, :csv_file_file_name
		remove_column :live_birth_data_updates, :csv_file_content_type
		remove_column :live_birth_data_updates, :csv_file_file_size
		remove_column :live_birth_data_updates, :csv_file_updated_at
	end
end
