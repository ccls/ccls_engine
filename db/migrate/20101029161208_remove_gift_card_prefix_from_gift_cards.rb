class RemoveGiftCardPrefixFromGiftCards < SharedMigration
	def self.up
		remove_index :gift_cards, :gift_card_number
		rename_column :gift_cards, :gift_card_issued_on,  :issued_on
		rename_column :gift_cards, :gift_card_expiration, :expiration
		rename_column :gift_cards, :gift_card_type,       :vendor
		rename_column :gift_cards, :gift_card_number,     :number
		add_index :gift_cards, :number, :unique => true
	end

	def self.down
		remove_index :gift_cards, :number
		rename_column :gift_cards, :issued_on,  :gift_card_issued_on
		rename_column :gift_cards, :expiration, :gift_card_expiration
		rename_column :gift_cards, :vendor,     :gift_card_type
		rename_column :gift_cards, :number,     :gift_card_number
		add_index :gift_cards, :gift_card_number, :unique => true
	end
end
