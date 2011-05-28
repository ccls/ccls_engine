# A subject's phone number
class PhoneNumber < Shared
	acts_as_list :scope => :study_subject_id
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :phone_type

	# because subject now accepts_nested_attributes for phone_numbers
	# we can't require subject_id on create
#	validates_presence_of   :subject, :on => :update

	validates_presence_of :phone_number
#
#	TODO again, try using a method for the :with
#
	validates_format_of :phone_number,
	  :with => /\A(\D*\d\D*){10}\z/

	validates_presence_of :why_invalid,
		:if => :is_not_valid?
	validates_presence_of :how_verified,
		:if => :is_verified?

	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :why_invalid
		o.validates_length_of :how_verified
	end

	named_scope :current, :conditions => [
		'current_phone IS NOT NULL AND current_phone != 2'
	]

	named_scope :historic, :conditions => [
		'current_phone IS NULL OR current_phone = 2'
	]

	before_save :format_phone_number

	before_save :set_verifier, 
		:if => :is_verified?, 
		:unless => :is_verified_was

	before_save :nullify_verifier, 
		:unless => :is_verified?,
		:if => :is_verified_was

	attr_accessor :current_user

	#	Returns boolean of comparison
	#	true only if is_valid == 2 or 999
	def is_not_valid?
		[2,999].include?(is_valid)
	end

protected

	#	Set verified time and user if given
	def set_verifier
		self.verified_on = Time.now
		self.verified_by_id = current_user.try(:id)||0
	end

	#	Unset verified time and user
	def nullify_verifier
		self.verified_on = nil
		self.verified_by_id = nil
	end

	#	Formats phone numer with () and -
	def format_phone_number
		unless self.phone_number.nil?
			old = self.phone_number.gsub(/\D/,'')
			new_phone = "(#{old[0..2]}) #{old[3..5]}-#{old[6..9]}"
			self.phone_number = new_phone
		end
	end

end
