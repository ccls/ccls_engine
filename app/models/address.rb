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

	validate :address_type_matches_line

	validates_presence_of :address_type
	validates_presence_of :line_1
	validates_length_of   :line_1, :maximum => 250, :allow_blank => true
	validates_length_of   :line_2, :maximum => 250, :allow_blank => true
	validates_length_of   :unit,   :maximum => 250, :allow_blank => true
	validates_presence_of :city
	validates_length_of   :city,   :maximum => 250, :allow_blank => true
	validates_presence_of :state
	validates_length_of   :state,  :maximum => 250, :allow_blank => true
	validates_presence_of :zip
	validates_length_of   :zip, :maximum => 10, :allow_blank => true

	validates_format_of :zip,
		:with => /\A\s*\d{5}(-)?(\d{4})?\s*\z/,
		:message => "should be 12345 or 12345-1234", :allow_blank => true

	attr_accessor :subject_moved

	after_save :create_subject_moved_event, :if => :subject_moved

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

	def create_subject_moved_event
		#	subject_moved will most likely be a string 'true' or 'false'
		#		as it will really only come as a hash value from a view.
		#	.true? is a common_lib#object method.
		if subject_moved.true?
			ccls_enrollment = study_subject.enrollments.find_or_create_by_project_id(
				Project['ccls'].id)
			ccls_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => OperationalEventType['subject_moved'],
				:occurred_on            => Date.today
			)
		end
	end

end
