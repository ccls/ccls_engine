class SharedMigration < ActiveRecord::Migration
	def self.database_model
		return "Shared"
	end
end
