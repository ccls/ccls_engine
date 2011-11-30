# don't know exactly
class DataSource < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	validates_presence_of   :code
	validates_length_of     :code,        :maximum => 250, :allow_blank => true
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_length_of     :description, :maximum => 250, :allow_blank => true
	validates_length_of     :research_origin, :maximum => 250, :allow_blank => true
	validates_length_of     :data_origin,     :maximum => 250, :allow_blank => true

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

	#	Returns boolean of comparison
	#	true only if code == 'other'
	def is_other?
		code == 'other'
	end

end
