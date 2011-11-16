# The type of phone number (home,work,mobile,etc.)
class PhoneType < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	acts_as_list
	has_many :phone_numbers

	validates_presence_of   :code
	validates_length_of     :code, :in => 4..250, :allow_blank => true
	validates_uniqueness_of :code
	validates_length_of     :description, :maximum => 250, :allow_blank => true

	#	Returns code
	def to_s
		code
	end

#	class NotFound < StandardError; end

	#	Treats the class a bit like a Hash and
	#	searches for a record with a matching code.
	def self.[](code)
		find_by_code(code.to_s) #|| raise(NotFound)
	end

end
