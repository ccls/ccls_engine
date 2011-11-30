#	don't know exactly
class VitalStatus < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	has_many :study_subjects

	validates_presence_of   :key
	validates_uniqueness_of :key
	validates_length_of     :key, :maximum => 250, :allow_blank => true
	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_presence_of   :description
	validates_uniqueness_of :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

#	class NotFound < StandardError; end
#
	def self.[](key)
		find_by_key(key.to_s) #|| raise(NotFound)
	end

end
