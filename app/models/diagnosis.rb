#	don't know
class Diagnosis < Shared
	acts_as_list
	default_scope :order => :position

#	has_many :subjects

	validates_presence_of   :code
	validates_uniqueness_of :code, :description
	validates_length_of     :description, :in => 3..250

	#	Return description
	def to_s
		description
	end

#	TODO add key and basic hash-like searching

end
