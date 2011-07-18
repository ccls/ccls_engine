class CreateBcRequests < SharedMigration
	def self.up
		create_table :bc_requests do |t|
			t.integer :study_subject_id
			t.date    :sent_on
			t.string  :status
			t.text    :notes
			t.timestamps
		end
	end

	def self.down
		drop_table :bc_requests
	end
end
