class CreateTracksTable < SharedMigration
	def self.up
		create_table :tracks do |t|
			t.references :trackable, :polymorphic => true
			t.string :name
			t.string :location
			t.string :city
			t.string :state
			t.string :zip
			t.datetime :time
			t.timestamps
		end
		#	Can't be two places at once!
		add_index :tracks, [:trackable_id, :trackable_type, :time], 
			:unique => true
	end

	def self.down
		drop_table :tracks
	end
end
