class AddHasIrbWaiverToHospital < SharedMigration
	def self.up
		add_column :hospitals, :has_irb_waiver, :boolean, :null => false, :default => false
	end

	def self.down
		remove_column :hospitals, :has_irb_waiver
	end
end
