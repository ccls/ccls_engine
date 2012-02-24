#	==	requires
#	*	code ( unique )
#	*	description ( > 3 chars )
class FollowUpType < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	has_many :follow_ups

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_length_of     :description, :in => 4..250, :allow_blank => true

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

	#	Returns description
	def to_s
		description
	end

end
