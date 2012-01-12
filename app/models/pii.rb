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
	attr_accessor :subject_is_mother, :subject_is_father

	attr_protected :study_subject_id

	before_validation :nullify_blank_fields

	validate :presence_of_dob, :unless => :dob_not_required?
	validates_complete_date_for :dob,     :allow_nil => true
	validates_complete_date_for :died_on, :allow_nil => true
	validates_uniqueness_of     :email,   :allow_nil => true

	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	validate :presence_of_guardian_relationship_other,
		:if => :guardian_relationship_is_other?

	validates_presence_of :birth_city,
		:if => :birth_country_is_united_states?
	validates_presence_of :birth_state,
		:if => :birth_country_is_united_states?

	validates_length_of :first_name, :last_name, 
		:middle_name, :maiden_name, :guardian_relationship_other,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:mother_race_other, :father_race_other,
		:birth_city, :birth_state, :birth_country,
			:maximum => 250, :allow_blank => true

 	validates_length_of :generational_suffix, :father_generational_suffix, 
		:maximum => 10, :allow_blank => true

 	validates_length_of :birth_year, :maximum => 4, :allow_blank => true

	def birth_country_is_united_states?
		birth_country == 'United States'
	end

	#	study_subject is not known at validation on creation
	#	when using the accepts_nested_attributes feature
	#	so we must explicitly set a flag.
	def dob_not_required?
		subject_is_mother || subject_is_father || 
			( subject_type == SubjectType['Mother'] ) ||
			( subject_type == SubjectType['Father'] )
#			( study_subject.try(:subject_type) == SubjectType['Mother'] ) ||
#			( study_subject.try(:subject_type) == SubjectType['Father'] )
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
		fathersname = [father_first_name, father_middle_name, father_last_name].compact.join(' ')
		( fathersname.blank? ) ? '[name not available]' : fathersname
	end

	#	Returns string containing study_subject's mother's first, middle and last name
	def mothers_name
		mothersname = [mother_first_name, mother_middle_name, mother_last_name].compact.join(' ')
		( mothersname.blank? ) ? '[name not available]' : mothersname
	end

	#	Returns string containing study_subject's guardian's first, middle and last name
	def guardians_name
		guardiansname = [guardian_first_name, guardian_middle_name, guardian_last_name].compact.join(' ')
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
		self.first_name = nil if first_name.blank?
		self.middle_name = nil if middle_name.blank?
		self.last_name = nil if last_name.blank?
		self.father_first_name = nil if father_first_name.blank?
		self.father_middle_name = nil if father_middle_name.blank?
		self.father_last_name = nil if father_last_name.blank?
		self.mother_first_name = nil if mother_first_name.blank?
		self.mother_middle_name = nil if mother_middle_name.blank?
		self.mother_maiden_name = nil if mother_maiden_name.blank?
		self.mother_last_name = nil if mother_last_name.blank?
		self.guardian_first_name = nil if guardian_first_name.blank?
		self.guardian_middle_name = nil if guardian_middle_name.blank?
		self.guardian_last_name = nil if guardian_last_name.blank?
	end

	#	custom validation for custom message without standard attribute prefix
	def presence_of_guardian_relationship_other
		if guardian_relationship_other.blank?
			errors.add(:guardian_relationship_other, ActiveRecord::Error.new(
				self, :base, :blank, { 
					:message => "You must specify a relationship with 'other relationship' is selected." } ) )
		end
	end

	#	custom validation for custom message without standard attribute prefix
	def presence_of_dob
		if dob.blank?
			errors.add(:dob, ActiveRecord::Error.new(
				self, :base, :blank, { 
					:message => "Date of birth can't be blank." } ) )
		end
	end

end
