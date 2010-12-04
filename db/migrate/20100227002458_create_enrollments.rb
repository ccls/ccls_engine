class CreateEnrollments < SharedMigration
	def self.up
		create_table :enrollments do |t|
			t.integer :position
			t.references :subject
			t.references :project
			t.string :recruitment_priority
			t.boolean :able_to_locate
			t.boolean :is_candidate
			t.boolean :is_eligible
			t.references :ineligible_reason
			t.string :ineligible_reason_specify
			t.boolean :consented
			t.date :consented_on
			t.references :refusal_reason
			t.string :other_refusal_reason
			t.boolean :is_chosen
			t.string :reason_not_chosen
			t.boolean :terminated_participation
			t.string :terminated_reason
			t.boolean :is_complete
			t.date :completed_on
			t.boolean :is_closed
			t.string :reason_closed
			t.text :notes
			t.timestamps
		end
		add_index :enrollments, [:project_id, :subject_id],
			:unique => true
	end

	def self.down
		drop_table :enrollments
	end
end
