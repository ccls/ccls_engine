# don't know exactly
class Hospital < Shared
	acts_as_list
	belongs_to :organization

	def to_s
		organization.try(:name) || 'Unknown'
	end

end
