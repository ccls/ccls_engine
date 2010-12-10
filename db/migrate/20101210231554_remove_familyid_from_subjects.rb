class RemoveFamilyidFromSubjects < SharedMigration
	def self.up
		remove_index  :subjects, :familyid
		remove_column :subjects, :familyid
	end

	def self.down
		add_column :subjects, :familyid, :string, :limit => 6
		add_index  :subjects, :familyid, :unique => true
	end
end
