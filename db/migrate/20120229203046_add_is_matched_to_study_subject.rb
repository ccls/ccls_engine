class AddIsMatchedToStudySubject < SharedMigration
	def self.up
		add_column :study_subjects, :is_matched, :boolean
	end

	def self.down
		remove_column :study_subjects, :is_matched
	end
end
