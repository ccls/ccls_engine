class ChangeCodeToIntegerInVitalStatuses < SharedMigration
	def self.up
		change_column :vital_statuses, :code, :integer, :null => false
	end

	def self.down
		change_column :vital_statuses, :code, :string, :null => false
	end
end
