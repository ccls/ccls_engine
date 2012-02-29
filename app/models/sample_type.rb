#	==	requires
#	*	description ( unique and > 3 chars )
class SampleType < ActiveRecordShared

	acts_as_list :scope => :parent_id
#	default_scope :order => :position
	default_scope :order => 'parent_id, position, description ASC'

	has_many :samples

	belongs_to :parent, :class_name => 'SampleType'
	has_many :children, 
		:class_name => 'SampleType',
		:foreign_key => 'parent_id',
		:dependent => :nullify
	
	named_scope :roots, :conditions => { :parent_id => nil }

	named_scope :not_roots, :conditions => [
		'sample_types.parent_id IS NOT NULL' ]

#
#	NOTE code seems to be a bit pointless in this model
#

	validates_presence_of   :code
	validates_uniqueness_of :code
	validates_length_of     :code, :maximum => 250, :allow_blank => true
	validates_presence_of   :description
	validates_length_of     :description, :in => 4..250, :allow_blank => true
	validates_uniqueness_of :description

	#	Returns description
	def to_s
		description
	end

end
