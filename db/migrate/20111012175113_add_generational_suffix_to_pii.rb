class AddGenerationalSuffixToPii < SharedMigration
	def self.up
		add_column :piis, :generational_suffix, :string, :limit => 10
	end

	def self.down
		remove_column :piis, :generational_suffix
	end
end
