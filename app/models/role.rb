class Role < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	has_and_belongs_to_many :users, :uniq => true
	validates_presence_of   :name
	validates_uniqueness_of :name
end
