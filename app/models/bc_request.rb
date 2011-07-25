class BcRequest < Shared

	belongs_to :subject, :foreign_key => 'study_subject_id'
	attr_protected :study_subject_id
	def self.statuses
		%w( active waitlist pending complete )
	end

end
