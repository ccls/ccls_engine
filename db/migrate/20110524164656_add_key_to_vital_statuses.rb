class AddKeyToVitalStatuses < SharedMigration
	def self.up
		add_column :vital_statuses, :key, :string
		add_index  :vital_statuses, :key, :unique => true
	end

	def self.down
		remove_index  :vital_statuses, :key
		remove_column :vital_statuses, :key
	end
end
