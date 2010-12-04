class AddLatestEventToPackage < SharedMigration
	def self.up
		add_column :packages, :latest_event, :string
	end

	def self.down
		remove_column :packages, :latest_event
	end
end
