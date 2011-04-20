class AddGuardianNamesToPiis < SharedMigration
	def self.up
		add_column :piis, :guardian_first_name, :string
		add_column :piis, :guardian_middle_name, :string
		add_column :piis, :guardian_last_name, :string
		add_column :piis, :guardian_relationship_id, :integer
		add_column :piis, :guardian_relationship_other, :string
	end

	def self.down
		remove_column :piis, :guardian_relationship_other
		remove_column :piis, :guardian_relationship_id
		remove_column :piis, :guardian_last_name
		remove_column :piis, :guardian_middle_name
		remove_column :piis, :guardian_first_name
	end
end
