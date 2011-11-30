#	==	requires
#	*	description (unique and >3 chars)
class Context < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	has_many :units
#	has_many :people

	has_many :context_data_sources
	has_many :data_sources, :through => :context_data_sources

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_presence_of   :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true
	validates_uniqueness_of :description

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end
