#	The type of address (home,work,residence,pobox,etc.)
class AddressType < ActiveRecordShared

	acts_as_list
	default_scope :order => :position

	acts_like_a_hash
	has_many :addresses

	#	Returns the key
	def to_s
		self.key
	end

end
