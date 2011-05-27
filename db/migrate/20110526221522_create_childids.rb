class CreateChildids < SharedMigration
	def self.up
		create_table :childids, :options => 'AUTO_INCREMENT=12000' do |t|
			t.timestamps
		end
	end

	def self.down
		drop_table :childids
	end
end
