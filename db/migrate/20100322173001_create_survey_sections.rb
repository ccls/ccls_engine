class CreateSurveySections < SharedMigration
	def self.up
		create_table :survey_sections do |t|
			# Context
			t.integer :survey_id
			
			# Content
			t.string :title
			t.text :description
			
			# Reference
			t.string :reference_identifier # from paper
			t.string :data_export_identifier # data export
			t.string :common_namespace # maping to a common vocab
			t.string :common_identifier # maping to a common vocab
			
			# Display
			t.integer :display_order
			
			t.string :custom_class

			t.timestamps
		end
		add_index :survey_sections, :survey_id
	end

	def self.down
		drop_table :survey_sections
	end
end
