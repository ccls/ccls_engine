#	Address for a study_subject
#	Actually, this may be used for things other than subjects
class Address < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	default_scope :order => 'created_at DESC'

	has_many :interviews
	has_one :addressing
	has_one :study_subject, :through => :addressing
	belongs_to :address_type
	belongs_to :data_source

	validates_presence_of :address_type_id
#	validates_presence_of :address_type
	validate :address_type_matches_line

	validates_presence_of :line_1, :city, :state, :zip
	validates_length_of   :line_1, :line_2, :unit, :city, :state,
			:maximum => 250, :allow_blank => true

	validates_length_of :zip, :maximum => 10

#	TODO again, perhaps replace the inline regex with a method that returns it
	validates_format_of :zip,
		:with => /\A\s*\d{5}(-)?(\d{4})?\s*\z/,
		:message => "should be 12345 or 12345-1234"

	# TODO it would probably be better to do this before_validation
	before_save :format_zip

	#	Returns a string with the city, state and zip
	def csz
		"#{self.city}, #{self.state} #{self.zip}"
	end

protected

	#	Determine if the address is a PO Box and then
	#	require that the address type NOT be a residence.
	def address_type_matches_line
		#	It is inevitable that this will match too much
		if(( line_1 =~ /p.*o.*box/i ) &&
			( address_type_id.to_s == '1' ))	#	1 is 'residence'
			errors.add(:address_type_id,
				"must not be residence with PO Box") 
		end
	end

	#	Simply squish the zip removing leading and trailing spaces.
	def format_zip
		#	zip was nil during import and skipping validations
		self.zip.squish! unless zip.nil?
	end

end
