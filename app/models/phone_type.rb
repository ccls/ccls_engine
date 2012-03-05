# The type of phone number (home,work,mobile,etc.)
class PhoneType < ActiveRecordShared

	acts_as_list
	acts_like_a_hash
	has_many :phone_numbers

	#	Returns key
	def to_s
		key
	end

end
