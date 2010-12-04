#	==	requires
#	*	sample_id
#	*	unit_id
#	*	owner_id
class Aliquot < Shared
	belongs_to :sample
	belongs_to :unit
	belongs_to :aliquot_sample_format

	#	rdoc_rails docs this incorrectly.  The :counter_cache 
	#	is causing the class_name to be ignored.  Using the
	#	column name rather than true seems to fix.
	#	( I am working on the plugin to fix this. )
	belongs_to :owner, 
		:class_name => "Organization"
#		:counter_cache => :aliquots_count

	has_many :transfers

	validates_presence_of :sample, :unit, :owner,
		:sample_id, :unit_id, :owner_id
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :location
		o.validates_length_of :mass
	end

	#	Create a #Transfer for the given #Aliquot from the 
	#	current owner(#Organization) to the given #Organization.
	def transfer_to(organization)
		org = Organization.find(organization)
		#	I don't think that the transaction is necessary
		#	but I also don't think that it will hurt.
		Aliquot.transaction do
			#	wrap this in a transaction because
			#	we don't want the aliquot.owner being
			#	out of sync with the last transfer.to
			self.transfer.to(org).save!
		end
	end

protected

	#	Begin building the #Transfer from the current
	#	owner(#Organization)
	def transfer
		Transfer.new({
			:aliquot_id => self.id,
			:from_organization_id => self.owner_id
		})
	end

end
