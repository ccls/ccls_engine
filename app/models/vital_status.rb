#	don't know exactly
class VitalStatus < Shared
	acts_as_list
	default_scope :order => :position

	has_many :subjects

	validates_presence_of   :key
	validates_uniqueness_of :key
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :description, :minimum => 4
	validates_uniqueness_of :description

#	with_options :maximum => 250, :allow_blank => true do |o|
	with_options :maximum => 250 do |o|
		o.validates_length_of :key
#		o.validates_length_of :code
		o.validates_length_of :description
	end

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
