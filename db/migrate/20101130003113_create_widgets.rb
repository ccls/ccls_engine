class CreateWidgets < ActiveRecord::Migration
	def self.database_model
		return "Widget"
	end

	def self.up
		create_table :widgets do |t|
			t.references :maker
			t.string :name
			t.timestamps
		end
	end

	def self.down
		drop_table :widgets
	end
end