class BcRequest < Shared

	belongs_to :study_subject
	attr_protected :study_subject_id

	validates_length_of :request_type, :status, :maximum => 250, :allow_blank => true

	def self.statuses
		%w( active waitlist pending complete )
	end

end
