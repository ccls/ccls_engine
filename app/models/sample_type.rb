#	==	requires
#	*	description ( unique and > 3 chars )
class SampleType < ActiveRecordShared

	acts_as_list :scope => :parent_id
#	default_scope :order => :position
	default_scope :order => 'parent_id, position, description ASC'

	acts_like_a_hash

	has_many :samples

	belongs_to :parent, :class_name => 'SampleType'
	has_many :children, 
		:class_name => 'SampleType',
		:foreign_key => 'parent_id',
		:dependent => :nullify
	
	named_scope :roots, :conditions => { :parent_id => nil }

	named_scope :not_roots, :conditions => [
		'sample_types.parent_id IS NOT NULL' ]

	#	Returns description
	def to_s
		description
	end

end
