class AddFamilyidToSubjects < SharedMigration
	def self.up
		add_column :subjects, :familyid, :string, :limit => 6
		add_index  :subjects, :familyid, :unique => true
	end

	def self.down
		remove_index  :subjects, :familyid
		remove_column :subjects, :familyid
	end
end
