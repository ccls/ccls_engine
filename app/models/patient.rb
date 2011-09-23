# Patient related study_subject info.
class Patient < Shared
	belongs_to :study_subject
	belongs_to :organization
	belongs_to :diagnosis


#
#	TODO - Don't validate anything that the creating user can't do anything about.
#

	##	TODO - find a better way to do this
	# because study_subject accepts_nested_attributes for patient
	# we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	attr_protected          :study_subject_id
	validates_presence_of   :study_subject,    :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true
	#
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the study_subject creation too if using nested attributes.
	#	I don't know that this is ever really an even possible issue
	#	as there is no way to directly create one.
	before_create :ensure_presence_of_study_subject_id


	validates_past_date_for :admit_date
	validates_past_date_for :diagnosis_date
	validate :admit_date_is_after_dob
	validate :diagnosis_date_is_after_dob
	validate :subject_is_case

	validates_complete_date_for :admit_date,
		:allow_nil => true
	validates_complete_date_for :diagnosis_date,
		:allow_nil => true

	validates_length_of :raf_zip, :maximum => 10, :allow_blank => true

	validates_format_of :raf_zip,
		:with => /\A\s*\d{5}(-)?(\d{4})?\s*\z/,
		:message => "should be 12345 or 12345-1234",
		:allow_blank => true

	#	TODO it would probably be better to do this before_validation
	before_save :format_zip

	after_save :trigger_update_matching_study_subjects_reference_date,
		:if => :admit_date_changed?

	after_save :trigger_setting_was_under_15_at_dx,
		:if => :admit_date_changed?

protected

	#	Simply squish the zip removing leading and trailing spaces.
	def format_zip
		#	zip was nil during import and skipping validations
		self.raf_zip.squish! unless raf_zip.nil?
	end

	def trigger_setting_was_under_15_at_dx
		study_subject.update_patient_was_under_15_at_dx
	end

	def trigger_update_matching_study_subjects_reference_date
		logger.debug "DEBUG: triggering_update_matching_study_subjects_reference_date from Patient:#{self.attributes['id']}"
		logger.debug "DEBUG: Admit date changed from:#{admit_date_was}:to:#{admit_date}"
		logger.debug "DEBUG: study_subject:#{study_subject.id}"
#		study_subject.update_matching_study_subjects_reference_date
		study_subject.update_study_subjects_reference_date_matching
	end

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the study_subject creation too if using nested attributes.
#	there is no uniqueness check anymore
	def ensure_presence_of_study_subject_id
		if study_subject_id.blank?
			errors.add(:study_subject_id, :blank )
			return false
		#	As this is only on create, we don't need to consider self.id
#		elsif Patient.exists?(:study_subject_id => study_subject_id)
#			errors.add(:study_subject_id, :taken )
#			return false
		end
	end

	##
	#	This validation does not work when using nested attributes as 
	#	the study_subject has not been resolved yet, unless this is an update.
	#	This results in a similar validation in Subject.
	def admit_date_is_after_dob
		if !admit_date.blank? && 
			!study_subject.blank? && 
			!study_subject.dob.blank? && 
			admit_date < study_subject.dob
			errors.add(:admit_date, "is before study_subject's dob.") 
		end
	end

	##
	#	This validation does not work when using nested attributes as 
	#	the study_subject has not been resolved yet, unless this is an update.
	#	This results in a similar validation in Subject.
	def diagnosis_date_is_after_dob
		if !diagnosis_date.blank? && 
			!study_subject.blank? && 
			!study_subject.dob.blank? && 
			diagnosis_date < study_subject.dob
			errors.add(:diagnosis_date, "is before study_subject's dob.") 
		end
	end

	##
	#	This validation does not work when using nested attributes as 
	#	the study_subject has not been resolved yet, unless this is an update.
	#	This results in a similar validation in Subject.
	def subject_is_case
#		if study_subject and study_subject.subject_type.code != 'Case'
		if study_subject and !study_subject.is_case?
			errors.add(:study_subject,"must be case to have patient info")
		end
	end

end
