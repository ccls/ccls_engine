#	==	requires
#	*	name ( unique and > 3 chars )
class Organization < Shared
	acts_as_list

	belongs_to :person

	has_many :aliquots, :foreign_key => 'owner_id'

	with_options :class_name => 'Transfer' do |o|
		o.has_many :incoming_transfers, 
			:foreign_key => 'to_organization_id'
		o.has_many :outgoing_transfers, 
			:foreign_key => 'from_organization_id'
	end

	has_many :hospitals
	has_many :patients

	validates_uniqueness_of :code
	validates_uniqueness_of :name
	validates_length_of :code, :in => 4..250
	validates_length_of :name, :in => 4..250

	#	Returns name
	def to_s
		name
	end

end
