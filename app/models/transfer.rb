#	==	requires
#	*	aliquot_id
#	*	from_organization_id
#	*	to_organization_id
class Transfer < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :aliquot
	belongs_to :from_organization, :class_name => "Organization"
	belongs_to :to_organization,   :class_name => "Organization"

# validate on foreign key rather than association so error shows up correctly in view.
#	validates_presence_of :aliquot
#	validates_presence_of :to_organization
#	validates_presence_of :from_organization
	validates_presence_of :aliquot_id
	validates_presence_of :to_organization_id
	validates_presence_of :from_organization_id

	validates_length_of   :reason, :maximum => 250, :allow_blank => true

	before_save :update_aliquot_owner

	#	Associate the given transfer "to" an #Organization
	def to(organization)
		self.to_organization = organization
		self
	end

protected

	#	Set associated aliquot's owner to the receiving #Organization.
	def update_aliquot_owner
		self.aliquot.update_attribute(:owner, self.to_organization)
	end

end


#	It would not surprise me if sent_on and received_on are added

#	This could also have a tracking_number and be tracked via active_shipping
