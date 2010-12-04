class AddHonorificToPeople < SharedMigration
	def self.up
		add_column :people, :honorific, :string, :limit => 20
	end

	def self.down
		remove_column :people, :honorific
	end
end
