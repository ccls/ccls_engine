class AddKeyToDiagnosis < SharedMigration
	def self.up
		add_column :diagnoses, :key, :string		#	NULL ?
		add_index	 :diagnoses, :key, :unique => true
	end

	def self.down
		remove_index  :diagnoses, :key, :unique => true
		remove_column :diagnoses, :key
	end
end
