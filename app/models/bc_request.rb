class BcRequest < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#

	belongs_to :study_subject
	attr_protected :study_subject_id

	validates_length_of :request_type, :maximum => 250, :allow_blank => true
	validates_length_of :status,       :maximum => 250, :allow_blank => true

	def self.statuses
		%w( active waitlist pending complete )
	end

end
