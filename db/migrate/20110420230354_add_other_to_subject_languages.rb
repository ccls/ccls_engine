class AddOtherToSubjectLanguages < SharedMigration
	def self.up
		add_column :subject_languages, :other, :string
	end

	def self.down
		remove_column :subject_languages, :other
	end
end
