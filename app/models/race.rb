#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Race < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position

	validates_presence_of   :key
	validates_uniqueness_of :key
	validates_length_of     :key, :maximum => 250, :allow_blank => true
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_presence_of   :description
	validates_uniqueness_of :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

	#	Returns description
	def name
		description
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching key.
	def self.[](key)
		find_by_key(key.to_s) #|| raise(NotFound)
	end

end
