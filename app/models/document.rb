class Document < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
	has_attached_file :document
end
