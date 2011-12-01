class SharedMigration < ActiveRecord::Migration
	def self.database_model
		return "ActiveRecordShared"
	end
end
