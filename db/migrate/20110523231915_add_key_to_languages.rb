class AddKeyToLanguages < SharedMigration
	def self.up
		add_column :languages, :key, :string
		add_index  :languages, :key, :unique => true
	end

	def self.down
		remove_index  :languages, :key
		remove_column :languages, :key
	end
end
