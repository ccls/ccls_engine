class CreateSamples < SharedMigration
	def self.up
		create_table :samples do |t|
			t.integer :position
			t.integer :parent_sample_id
			t.integer :aliquot_sample_format_id
			t.integer :sample_type_id
			t.integer :project_id
			t.integer :study_subject_id
			t.integer :unit_id
			t.integer :order_no, :default => 1
			t.decimal :quantity_in_sample
			t.string  :aliquot_or_sample_on_receipt, :default => 'Sample'
			t.date    :sent_to_subject_on
			t.datetime :collected_at
			t.datetime :shipped_at
			t.datetime :received_by_ccls_at
			t.date    :sent_to_lab_on
			t.date    :received_by_lab_on
			t.date    :aliquotted_on
			t.string  :external_id
			t.string  :external_id_source
			t.date    :receipt_confirmed_on
			t.string  :receipt_confirmed_by
			t.boolean :future_use_prohibited, :default => false, :null => false
			t.integer :location_id
			t.integer :sample_temperature_id
			t.timestamps
		end
	end

	def self.down
		drop_table :samples
	end
end
