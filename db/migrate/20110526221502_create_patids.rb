class CreatePatids < SharedMigration
	def self.up
		create_table :patids do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :patids
	end
end
