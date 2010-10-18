class CreatePhotos < ActiveRecord::Migration
	def self.up
		create_table :photos do |t|
			t.string :title, :null => false
			t.text   :caption
			t.timestamps
		end
	end

	def self.down
		drop_table :photos
	end
end
