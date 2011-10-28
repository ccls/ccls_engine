# don't know exactly
class Hospital < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	belongs_to :organization

	#	don't know if this is needed as database will default to false
#	validates_presence_of :has_irb_waiver

	def to_s
		organization.try(:name) || 'Unknown'
	end

end
