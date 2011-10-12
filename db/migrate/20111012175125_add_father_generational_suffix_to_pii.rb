class AddFatherGenerationalSuffixToPii < SharedMigration
	def self.up
		add_column :piis, :father_generational_suffix, :string, :limit => 10
	end

	def self.down
		remove_column :piis, :father_generational_suffix
	end
end
