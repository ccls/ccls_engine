class CreateDocumentTypes < SharedMigration
	def self.up
		create_table :document_types do |t|
			t.integer :position
			t.string  :title
			t.string  :description
			t.timestamps
		end
	end

	def self.down
		drop_table :document_types
	end
end
