class RenameEnrollmentsAbleToLocateToTracingStatusId < SharedMigration
	def self.up
		rename_column :enrollments, :able_to_locate, :tracing_status_id
	end

	def self.down
		rename_column :enrollments, :tracing_status_id, :able_to_locate
	end
end
