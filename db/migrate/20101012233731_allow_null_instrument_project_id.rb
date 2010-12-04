class AllowNullInstrumentProjectId < SharedMigration
	def self.up
		change_column :instruments, :project_id, :integer, :null => true
	end

	def self.down
		change_column :instruments, :project_id, :integer, :null => false
	end
end
