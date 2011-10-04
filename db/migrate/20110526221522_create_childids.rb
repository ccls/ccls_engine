class CreateChildids < SharedMigration
	def self.up
#	FYI: these options do not get duplicated into the test db!
#		create_table :childids, :options => 'AUTO_INCREMENT=12000' do |t|
		create_table :childids, :options => 'AUTO_INCREMENT=15000' do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :childids
	end
end
