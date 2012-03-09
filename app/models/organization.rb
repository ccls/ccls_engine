#	==	requires
#	*	name ( unique and > 3 chars )
class Organization < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash(:value => :name)

	belongs_to :person
	has_many :aliquots, :foreign_key => 'owner_id'
	has_many :incoming_transfers, :class_name => 'Transfer', 
		:foreign_key => 'to_organization_id'
	has_many :outgoing_transfers, :class_name => 'Transfer', 
		:foreign_key => 'from_organization_id'
#	has_many :hospitals
	has_one  :hospital
	has_many :patients

	validates_presence_of   :name
	validates_uniqueness_of :name

	#	Returns name
	def to_s
		name
	end

end
