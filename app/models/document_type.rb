class DocumentType < Shared
	acts_as_list
	default_scope :order => :position
	has_many :document_versions
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :title
		o.validates_length_of :description
	end
end
