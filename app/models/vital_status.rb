#	don't know exactly
class VitalStatus < Shared
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_presence_of   :key, :code, :description
	validates_uniqueness_of :key, :code, :description
	validates_length_of     :key, :maximum => 250
	validates_length_of     :description, :in => 4..250

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end
#
	def self.[](key)
		find_by_key(key.to_s) #|| raise(NotFound)
	end

end
