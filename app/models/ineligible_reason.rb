#	==	requires
#	*	description (unique and > 3 chars)
class IneligibleReason < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :enrollments

	validates_length_of     :ineligible_context, 
		:maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

	#	Returns boolean of comparison
	#	true only if key == 'other'
	def is_other?
		key == 'other'
	end

end
