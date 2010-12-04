class AddTrackingInfoToPackages < SharedMigration
	def self.up
		add_column :packages, :tracks_count, :integer, :default => 0
		add_column :packages, :tracking_number, :string
		add_index :packages, :tracking_number, :unique => true
	end

	def self.down
		remove_column :packages, :tracks_count
		remove_column :packages, :tracking_number
	end
end
