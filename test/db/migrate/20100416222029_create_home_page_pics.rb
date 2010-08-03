#		class CreateHomePagePics < ActiveRecord::Migration
#			def self.up
#				create_table :home_page_pics do |t|
#					t.string  :title
#					t.text    :caption
#					t.boolean :active, :default => true
#					t.timestamps
#				end
#				add_index :home_page_pics, :active
#			end
#		
#			def self.down
#				drop_table :home_page_pics
#			end
#		end
