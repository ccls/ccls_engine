# don't know exactly
class Hospital < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	belongs_to :organization

	#	don't know if this is needed as database will default to false
#	validates_presence_of :has_irb_waiver
	validates_inclusion_of :has_irb_waiver, :in => [ true, false ]

#	if organization_id is not unique, using find_by_organization_id as I do WILL cause problems
#	as it will only evern return the first match
	validates_presence_of   :organization
	validates_uniqueness_of :organization_id, :allow_blank => true
#	Remove current organization_id index and add a unique index??
#	Without it, the fixtures won't be tested when loaded.

	named_scope :waivered,    :conditions => { :has_irb_waiver => true }
	named_scope :nonwaivered, :conditions => { :has_irb_waiver => false }

	def to_s
		organization.try(:name) || 'Unknown'	#	organization is required now, so Unknown should never happen
	end

end
