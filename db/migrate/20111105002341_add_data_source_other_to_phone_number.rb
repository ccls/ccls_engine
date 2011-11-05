class AddDataSourceOtherToPhoneNumber < SharedMigration
	def self.up
	  add_column :phone_numbers, :data_source_other, :string
	end

	def self.down
	  remove_column :phone_numbers, :data_source_other
	end
end
