# == PII (Personally Identifiable Information)
#	==	requires
#	*	study_subject_id
class Pii < ActiveRecordShared

	belongs_to :study_subject
	belongs_to :guardian_relationship, :class_name => 'SubjectRelationship'

	delegate :is_other?,    :to => :guardian_relationship, :allow_nil => true, :prefix => true
	delegate :subject_type, :to => :study_subject, :allow_nil => true

	#	Basically, this is only used as a flag during nested creation
	#	to determine if the dob is required.
	attr_accessor :subject_is_mother
	
	#	Father seems to be irrelevant so commenting out code.
	#	attr_accessor :subject_is_father

	attr_protected :study_subject_id

	before_validation :nullify_blank_fields

	include PiiValidations

	#	Returns string containing study_subject's first, middle and last initials
	def initials
#		[first_name, middle_name, last_name]
		childs_names.delete_if(&:blank?).collect{|s|s.chars.first}.join()
	end

	def childs_names
		[first_name, middle_name, last_name ]
	end

	#	Returns string containing study_subject's first, middle and last name
	#	TODO include maiden_name just in case is mother???
	#	Use delete_if(&:blank?) instead of compact, which only removes nils.
	def full_name
		fullname = childs_names.delete_if(&:blank?).join(' ')
		( fullname.blank? ) ? '[name not available]' : fullname
	end

	def fathers_names
		[father_first_name, father_middle_name, father_last_name ]
	end

	#	Returns string containing study_subject's father's first, middle and last name
	def fathers_name
		fathersname = fathers_names.delete_if(&:blank?).join(' ')
		( fathersname.blank? ) ? '[name not available]' : fathersname
	end

	def mothers_names
		[mother_first_name, mother_middle_name, mother_last_name ]
	end

	#	Returns string containing study_subject's mother's first, middle and last name
	#	TODO what? no maiden name?
	def mothers_name
		mothersname = mothers_names.delete_if(&:blank?).join(' ')
		( mothersname.blank? ) ? '[name not available]' : mothersname
	end

	def guardians_names
		[guardian_first_name, guardian_middle_name, guardian_last_name ]
	end

	#	Returns string containing study_subject's guardian's first, middle and last name
	def guardians_name
		guardiansname = guardians_names.delete_if(&:blank?).join(' ')
		( guardiansname.blank? ) ? '[name not available]' : guardiansname
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

protected
#
# logger levels are ... debug, info, warn, error, and fatal.
#
	def trigger_setting_was_under_15_at_dx
		logger.debug "DEBUG: calling update_patient_was_under_15_at_dx from Pii:#{self.attributes['id']}"
		logger.debug "DEBUG: DOB changed from:#{dob_was}:to:#{dob}"
		if study_subject
			logger.debug "DEBUG: study_subject:#{study_subject.id}"
			study_subject.update_patient_was_under_15_at_dx
		else
			# This should never happen, except in testing.
			logger.warn "WARNING: Pii(#{self.attributes['id']}) is missing study_subject"
		end
	end

	def nullify_blank_fields
		#	An empty form field is not NULL to MySQL so ...
		self.email = nil if email.blank?

#	Why did these matter?
#		self.first_name = nil if first_name.blank?
#		self.middle_name = nil if middle_name.blank?
#		self.last_name = nil if last_name.blank?
#		self.father_first_name = nil if father_first_name.blank?
#		self.father_middle_name = nil if father_middle_name.blank?
#		self.father_last_name = nil if father_last_name.blank?
#		self.mother_first_name = nil if mother_first_name.blank?
#		self.mother_middle_name = nil if mother_middle_name.blank?
#		self.mother_maiden_name = nil if mother_maiden_name.blank?
#		self.mother_last_name = nil if mother_last_name.blank?
#		self.guardian_first_name = nil if guardian_first_name.blank?
#		self.guardian_middle_name = nil if guardian_middle_name.blank?
#		self.guardian_last_name = nil if guardian_last_name.blank?
	end

end
