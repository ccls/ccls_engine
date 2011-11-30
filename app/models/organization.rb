#	==	requires
#	*	name ( unique and > 3 chars )
class Organization < ActiveRecordShared

	acts_as_list

	belongs_to :person
	has_many :aliquots, :foreign_key => 'owner_id'
	has_many :incoming_transfers, :class_name => 'Transfer', :foreign_key => 'to_organization_id'
	has_many :outgoing_transfers, :class_name => 'Transfer', :foreign_key => 'from_organization_id'
#	has_many :hospitals
	has_one  :hospital
	has_many :patients

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :code, :in => 4..250, :allow_blank => true
	validates_presence_of   :name
	validates_uniqueness_of :name
	validates_length_of     :name, :in => 4..250, :allow_blank => true

	#	Returns name
	def to_s
		name
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end
