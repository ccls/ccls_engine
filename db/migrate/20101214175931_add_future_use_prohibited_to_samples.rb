class AddFutureUseProhibitedToSamples < SharedMigration
	def self.up
		add_column :samples, :future_use_prohibited, :boolean, :default => false, :null => false
	end

	def self.down
		remove_column :samples, :future_use_prohibited
	end
end
