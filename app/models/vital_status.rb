#	don't know exactly
class VitalStatus < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	has_many :study_subjects

#	validates_presence_of   :code
#	validates_uniqueness_of :code

	#	Returns description
	def to_s
		description
	end

end
