# The type of phone number (home,work,mobile,etc.)
class PhoneType < Shared
	has_many :phone_numbers
	acts_as_list
	validates_presence_of   :code
	validates_length_of     :code, :minimum => 4
	validates_uniqueness_of :code

#	TODO make this smaller
	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :code
		o.validates_length_of :description
	end

	#	Returns code
	def to_s
		code
	end

end
