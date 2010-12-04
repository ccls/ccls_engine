class DropHomeExposureEvents < SharedMigration
	def self.up
		drop_table :home_exposure_events
	end

	def self.down
		create_table :home_exposure_events do |t|
			t.references :subject
			t.date :initial_letter_sent_on
			t.integer :interview_outcome_id
			t.date :interview_outcome_date
			t.integer :dust_sample_outcome_id
			t.date :dust_sample_outcome_date
			t.integer :home_exposure_outcome_id
			t.date :home_exposure_outcome_date
			t.timestamps
		end
	end
end
