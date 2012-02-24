class TracingStatus < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	has_many :enrollments

	validates_presence_of   :code, :description
	validates_uniqueness_of :code, :description
	validates_length_of     :code, :description, :maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

#	#	Returns description
#	def name
#		description
#	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end
