class CreateIcfMasterIds < SharedMigration
	def self.up
		create_table :icf_master_ids do |t|
			t.string  :icf_master_id, :limit => 9
			t.date    :assigned_on
			t.integer :study_subject_id
			t.timestamps
		end
		add_index :icf_master_ids, :icf_master_id, :unique => true
		add_index :icf_master_ids, :study_subject_id, :unique => true
	end

	def self.down
		drop_table :icf_master_ids
	end
end
