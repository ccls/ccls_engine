#	==	requires
#	*	code ( unique )
#	*	description ( unique and > 3 chars )
class OperationalEventType < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	default_scope :order => :position

	has_many :operational_events

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_presence_of   :description
	validates_uniqueness_of :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true
	validates_presence_of   :event_category
	validates_uniqueness_of :event_category
	validates_length_of     :event_category, :in => 4..250, :allow_blank => true

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

	#	Returns event_category
	def to_s
#		description
		event_category
	end

end
