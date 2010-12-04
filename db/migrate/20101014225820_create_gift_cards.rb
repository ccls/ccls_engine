class CreateGiftCards < SharedMigration
	def self.up
		create_table :gift_cards do |t|
			t.references :subject
			t.references :project
			t.date :gift_card_issued_on
			t.string :gift_card_expiration, :limit => 25
			t.string :gift_card_type
			t.string :gift_card_number, :null => false
			t.timestamps
		end
		add_index :gift_cards, :gift_card_number, :unique => true
	end

	def self.down
		drop_table :gift_cards
	end
end
