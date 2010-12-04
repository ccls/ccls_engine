class AddIntroLetterSentOnToInterview < SharedMigration
	def self.up
		add_column :interviews, :intro_letter_sent_on, :date
	end

	def self.down
		remove_column :interviews, :intro_letter_sent_on
	end
end
