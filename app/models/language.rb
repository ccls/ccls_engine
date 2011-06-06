#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Language < Shared
	acts_as_list
	default_scope :order => :position

	has_many :interviews
	has_many :instrument_versions

	validates_presence_of   :key, :code
	validates_uniqueness_of :key, :code, :description
	validates_length_of     :description, :in => 4..250
	validates_length_of     :key, :code, :maximum => 250

	#	Returns description
	def to_s
		description
	end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching key.		#	key here NOT code
	def self.[](key)
		find_by_key(key.to_s) #|| raise(NotFound)
	end

	#	Returns boolean of comparison
	#	true only if key == 'other'
	def is_other?
		key == 'other'
	end

end
