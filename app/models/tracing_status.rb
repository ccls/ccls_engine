class TracingStatus < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :enrollments

	#	Returns description
	def to_s
		description
	end

#	#	Returns description
#	def name
#		description
#	end

end
