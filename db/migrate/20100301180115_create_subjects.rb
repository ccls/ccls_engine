class CreateSubjects < SharedMigration
	def self.up
		create_table :subjects do |t|
#			t.integer :position
			t.references :subject_type
			t.references :race
			t.references :vital_status
			t.references :hispanicity
#			t.references :operational_event
#			t.references :ineligible_reason
#			t.references :refusal_reason
#			t.string     :other_refusal_reason
			t.date :reference_date
#			t.boolean :is_hispanic
			t.integer :response_sets_count, :default => 0
			t.string :sex
			t.string :subjectid, :limit => 6
			t.boolean :do_not_contact, :default => false, :null => false
			t.timestamps
		end
		add_index :subjects, :subjectid, :unique => true
	end

	def self.down
		drop_table :subjects
	end
end
