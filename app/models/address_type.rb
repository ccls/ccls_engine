#	The type of address (home,work,residence,pobox,etc.)
class AddressType < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	has_many :addresses
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end

	#	Returns the code
	def to_s
		self.code
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end
