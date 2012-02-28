# don't know exactly
class DataSource < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	validates_presence_of   :code, :description
	validates_uniqueness_of :code
	validates_length_of     :code, :description, :data_origin,
		:other_organization, :other_person,
		:maximum => 250, :allow_blank => true

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
