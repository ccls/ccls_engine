class AddIsDuplicateOfToSubjects < SharedMigration
	def self.up
		add_column :subjects, :is_duplicate_of, :string, :limit => 6
	end

	def self.down
		remove_column :subjects, :is_duplicate_of
	end
end
