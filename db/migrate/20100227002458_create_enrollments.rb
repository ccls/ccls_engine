class CreateEnrollments < SharedMigration
	def self.up
		create_table :enrollments do |t|
			t.integer :position
			t.references :subject
			t.references :project
			t.string :recruitment_priority
			t.integer :able_to_locate
			t.integer :is_candidate
			t.integer :is_eligible
			t.references :ineligible_reason
			t.string :ineligible_reason_specify
			t.integer :consented
			t.date :consented_on
			t.references :refusal_reason
			t.string :other_refusal_reason
			t.integer :is_chosen
			t.string :reason_not_chosen
			t.integer :terminated_participation
			t.string :terminated_reason
			t.integer :is_complete
			t.date :completed_on
			t.boolean :is_closed
			t.string :reason_closed
			t.text :notes
			t.integer :document_version_id
			t.integer :project_outcome_id
			t.date :project_outcome_on
			t.timestamps
		end
		add_index :enrollments, [:project_id, :subject_id],
			:unique => true
	end

	def self.down
		drop_table :enrollments
	end
end
