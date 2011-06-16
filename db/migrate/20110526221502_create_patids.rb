class CreatePatids < SharedMigration
	def self.up
#	FYI: these options do not get duplicated into the test db!
#		create_table :patids, :options => 'AUTO_INCREMENT=1200'  do |t|
		create_table :patids, :options => 'AUTO_INCREMENT=2000'  do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :patids
	end
end
