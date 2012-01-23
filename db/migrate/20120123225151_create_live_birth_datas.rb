class CreateLiveBirthDatas < SharedMigration
	def self.up
		create_table :live_birth_datas do |t|

			t.timestamps
		end
	end

	def self.down
		drop_table :live_birth_datas
	end
end
