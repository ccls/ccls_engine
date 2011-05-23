class AddKeyToRaces < SharedMigration
	def self.up
		add_column :races, :key, :string
		add_index  :races, :key, :unique => true
	end

	def self.down
		remove_index  :races, :key
		remove_column :races, :key
	end
end
