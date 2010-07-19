class CreateDocuments < ActiveRecord::Migration
	def self.up
		create_table :documents do |t|
			t.references :owner
			t.string :title, :null => false
			t.text   :abstract
			t.boolean :shared_with_all, 
				:default => false, :null => false
			t.boolean :shared_with_select, 
				:default => false, :null => false
			t.timestamps
		end
		add_index :documents, :owner_id
	end

	def self.down
		drop_table :documents
	end
end
