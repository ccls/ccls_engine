#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Race < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position

#	Don't think that I ever user this relationship in this direction
#	has_many :study_subjects

	validates_presence_of   :key, :code
	validates_uniqueness_of :key, :code, :description
	validates_length_of     :description, :in => 4..250
	validates_length_of     :key, :code,  :maximum => 250

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
