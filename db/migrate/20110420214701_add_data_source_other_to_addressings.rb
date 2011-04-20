class AddDataSourceOtherToAddressings < SharedMigration
	def self.up
		add_column :addressings, :data_source_other, :string
	end

	def self.down
		remove_column :addressings, :data_source_other
	end
end
