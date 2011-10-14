# don't know exactly
class Hospital < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	belongs_to :organization

	def to_s
		organization.try(:name) || 'Unknown'
	end

end
