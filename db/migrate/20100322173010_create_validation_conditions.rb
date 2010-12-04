class CreateValidationConditions < SharedMigration
	def self.up
		create_table :validation_conditions do |t|
			# Context
			t.integer :validation_id
			t.string :rule_key
			
			# Conditional		
			t.string :operator
			
			# Optional external reference
			t.integer :question_id
			t.integer :answer_id

			# Value
			t.datetime :datetime_value
			t.integer :integer_value
			t.float :float_value
			t.string :unit
			t.text :text_value
			t.string :string_value
			t.string :response_other
			t.string :regexp
			
			t.timestamps
		end
		add_index :validation_conditions, :validation_id
	end

	def self.down
		drop_table :validation_conditions
	end
end
