# don't know exactly
class DataSource < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	default_scope :order => :position

	validates_length_of     :data_origin,
		:other_organization, :other_person,
		:maximum => 250, :allow_blank => true

	#	Returns description
	def to_s
		description
	end

	#	Returns boolean of comparison
	#	true only if key == 'other'
	def is_other?
		key == 'other'
	end

end
