class CreateEnrollments < SharedMigration
	def self.up
		create_table :enrollments do |t|
			t.integer :position
			t.references :study_subject
			t.references :project
			t.string :recruitment_priority
			t.integer :tracing_status_id
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
			t.integer :use_smp_future_rsrch
			t.integer :use_smp_future_cancer_rsrch
			t.integer :use_smp_future_other_rsrch
			t.integer :share_smp_with_others
			t.integer :contact_for_related_study
			t.integer :provide_saliva_smp
			t.integer :receive_study_findings
			t.boolean :refused_by_physician
			t.boolean :refused_by_family
			t.timestamps
		end
		add_index :enrollments, [:project_id, :study_subject_id],
			:unique => true
	end

	def self.down
		drop_table :enrollments
	end
end
