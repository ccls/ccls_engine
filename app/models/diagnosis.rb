#	don't know
class Diagnosis < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	validates_presence_of   :code
	validates_uniqueness_of :code

	#	Return description
	def to_s
		description
	end

	#	Returns boolean of comparison
	#	true only if key == 'other'
	def is_other?
		key == 'other'
	end

end
