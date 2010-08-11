#	#82 new
#	Roles and Users
#	
#	Reported by Magee | August 9th, 2010 @ 02:11 PM
#	
#	Currently we should have four roles (three in 
#	the system right now). They are effectively as follows:
#	
#	1. Reader -- users with login accounts who can 
#		view contents of sections but not edit anything.
#	2. Editor -- users with the ability to add or edit 
#		content to the system. These are the users for 
#		whom an "edit" button displays on content details 
#		pages allowing them to make changes 
#		(or an "add" button as appropriate)
#	3. Administrator -- users who have administrative 
#		rights to the system to add users, etc.
#	4. Superuser -- Magee and Jake
#	
#	There may not be any system behaviors defined for 
#	Superusers. They may strictly be Conceptual Roles 
#	to describe users who may make backend or other 
#	changes outside of the scope of normal system 
#	operations. If necessary, a system role may be 
#	added in the future to address functions only 
#	for that group.
#	
class Role < ActiveRecord::Base
	acts_as_list
	default_scope :order => :position
	has_and_belongs_to_many :users, :uniq => true
	validates_presence_of   :name
	validates_uniqueness_of :name
end
