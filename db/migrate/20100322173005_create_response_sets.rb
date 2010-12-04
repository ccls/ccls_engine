class CreateResponseSets < SharedMigration
	def self.up
		create_table :response_sets do |t|
			# Context
			#	This is the current_user that started the survey.
			t.integer :user_id		
			t.integer :survey_id
#			t.integer :childid
			t.integer :subject_id

			# Content
			t.string :access_code #unique id for the object used in urls

			# Expiry
			t.datetime :started_at
			t.datetime :completed_at

			t.timestamps
		end
		#	Jake added this because it seems necessary.
		#	Despite the above statement "unique id ...", without
		#	this index, there is no guarantee that it is unique.
		add_index :response_sets, :access_code, :unique => true
		#	NOT unique
#		add_index :response_sets, :childid
		add_index :response_sets, :subject_id
	end

	def self.down
		drop_table :response_sets
	end
end
