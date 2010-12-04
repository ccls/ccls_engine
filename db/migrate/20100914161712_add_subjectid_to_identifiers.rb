class AddSubjectidToIdentifiers < SharedMigration
	def self.up
		add_column :identifiers, :subjectid, :string, :limit => 6
		add_index  :identifiers, :subjectid, :unique => true
	end

	def self.down
		remove_index  :identifiers, :subjectid
		remove_column :identifiers, :subjectid
	end
end
