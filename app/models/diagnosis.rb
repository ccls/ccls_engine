#	don't know
class Diagnosis < Shared
	acts_as_list
	default_scope :order => :position

#	has_many :subjects

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :in => 3..250
	validates_uniqueness_of :description

	#	Return description
	def to_s
		description
	end

end
