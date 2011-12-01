class CreateGiftCards < SharedMigration
	def self.up
		create_table :gift_cards do |t|
			t.references :study_subject
			t.references :project
			t.date :issued_on
			t.string :expiration, :limit => 25
			t.string :vendor
			t.string :number, :null => false
			t.timestamps
		end
		add_index :gift_cards, :number, :unique => true
	end

	def self.down
		drop_table :gift_cards
	end
end
