#	don't know exactly
class VitalStatus < Shared
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :in => 4..250

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end
#
#	def self.[](code)
#		find_by_code(code.to_s) || raise(NotFound)
#	end

end
