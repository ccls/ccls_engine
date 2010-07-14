class Document < ActiveRecord::Base
	belongs_to :owner, :class => 'User'
	has_attached_file :document
end
