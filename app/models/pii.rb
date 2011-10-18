# == PII (Personally Identifiable Information)
#	==	requires
#	*	study_subject_id
class Pii < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
	belongs_to :study_subject
	belongs_to :guardian_relationship, :class_name => 'SubjectRelationship'

	#	Basically, this is only used as a flag during nested creation
	#	to determine if the dob is required.
	attr_accessor :subject_is_mother, :subject_is_father

	attr_protected          :study_subject_id

	before_validation :nullify_blank_fields

	validates_presence_of       :dob, :unless => :dob_not_required?
	validates_complete_date_for :dob, :died_on, :allow_nil => true
	validates_uniqueness_of     :email, :allow_nil => true

	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	#
	#	NOTE I don't like the messaging here, but was requested to have a special
	#		failed validation message.  Normally, rails will give the attribute name
	#		followed by the error message.  I wrote some code that looks for the <|X|
	#		and if it finds it, only displays this message without the attribute.
	#
	validates_presence_of :guardian_relationship_other,
		:message => "<|X|You must specify a relationship with 'other relationship' is selected",
		:if => :guardian_relationship_is_other?

	validates_length_of :first_name, :last_name, 
		:middle_name, :maiden_name, :guardian_relationship_other,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
			:maximum => 250, :allow_blank => true

 	validates_length_of :generational_suffix, :father_generational_suffix, 
		:maximum => 10, :allow_blank => true

 	validates_length_of :birth_year, :maximum => 4, :allow_blank => true


	#	study_subject is not known at validation on creation
	#	when using the accepts_nested_attributes feature
	#	so we must explicitly set a flag.
	def dob_not_required?
		subject_is_mother || subject_is_father || 
			( study_subject.try(:subject_type) == SubjectType['Mother'] ) ||
			( study_subject.try(:subject_type) == SubjectType['Father'] )
	end

	#	Returns string containing study_subject's first, middle and last initials
	def initials
		[first_name, middle_name, last_name].compact.collect{|s|s.chars.first}.join()
	end

	#	Returns string containing study_subject's first, middle and last name
	#	TODO include maiden_name just in case is mother???
	def full_name
		fullname = [first_name, middle_name, last_name].compact.join(' ')
		( fullname.blank? ) ? '[name not available]' : fullname
	end

	#	Returns string containing study_subject's father's first, middle and last name
	def fathers_name
		[father_first_name, father_middle_name, father_last_name].compact.join(' ')
	end

	#	Returns string containing study_subject's mother's first, middle and last name
	def mothers_name
		[mother_first_name, mother_middle_name, mother_last_name].compact.join(' ')
	end

	#	Returns string containing study_subject's guardian's first, middle and last name
	def guardians_name
		[guardian_first_name, guardian_middle_name, guardian_last_name].compact.join(' ')
	end

#
#	TODO I hate this.  It is revolting.  More?  Yes, please.
#
	#	I don't know if I still need this
	#	commented out 20101014
	#	uncommented 20101014
	def dob	#	overwrite default dob method for formatting
		#	added to_date to fix sqlite3 quirk which doesn't	(why am I using sqlite3?)  old comment?
		#	differentiate between times and dates.
		read_attribute(:dob).try(:to_s,:dob).try(:to_date)
	end

	after_save :trigger_setting_was_under_15_at_dx,
		:if => :dob_changed?
	def trigger_setting_was_under_15_at_dx
		study_subject.update_patient_was_under_15_at_dx
	end

protected

	def nullify_blank_fields
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?
		self.first_name = nil if first_name.blank?
		self.middle_name = nil if middle_name.blank?
		self.last_name = nil if last_name.blank?
	end

	def guardian_relationship_is_other?
		guardian_relationship.try(:is_other?)
	end

end
