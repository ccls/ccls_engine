class CreateDocumentVersions < SharedMigration
	def self.up
		create_table :document_versions do |t|
			t.integer :position
			t.integer :document_type_id, :null => false
			t.string  :title
			t.string  :description
			t.string  :indicator
			t.integer :language_id
			t.date    :began_use_on
			t.date    :ended_use_on
			t.timestamps
		end
	end

	def self.down
		drop_table :document_versions
	end
end
