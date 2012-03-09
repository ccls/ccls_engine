class SampleTemperature < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash

	has_many :samples

	def to_s
		description
	end

end
