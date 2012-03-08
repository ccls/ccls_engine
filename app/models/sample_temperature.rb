class SampleTemperature < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :samples

	def to_s
		description
	end

end
