class AddMaidenNameToPiis < SharedMigration
	def self.up
		add_column :piis, :maiden_name, :string
	end

	def self.down
		remove_column :piis, :maiden_name
	end
end
