#	==	requires
#	*	description ( unique and > 3 chars )
class SampleType < Shared
	acts_as_list :scope => :parent_id
	default_scope :order => :position

	has_many :samples
	with_options :class_name => 'SampleType' do |o|
		o.belongs_to :parent
		o.has_many :children, 
			:foreign_key => 'parent_id',
			:dependent => :nullify
	end
	
	named_scope :roots, :conditions => { 
		:parent_id => nil }

	named_scope :not_roots, :conditions => [
		'sample_types.parent_id IS NOT NULL' ]

	validates_presence_of   :code
	validates_uniqueness_of :code, :description
	validates_length_of     :description, :in => 4..250
	validates_length_of     :code, :maximum => 250

	#	Returns description
	def to_s
		description
	end

end
