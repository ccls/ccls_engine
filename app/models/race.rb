#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class Race < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	validates_presence_of   :key, :code, :description
	validates_uniqueness_of :key, :code, :description
	validates_length_of     :key, :code, :maximum => 250, :allow_blank => true
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

	#	Returns boolean of comparison
	#	true only if key == 'other'
	def is_other?
		key == 'other'
	end

end
