# Patient related study_subject info.
class Patient < ActiveRecordShared

	belongs_to :study_subject
	belongs_to :organization
	belongs_to :diagnosis

	delegate :is_other?, :to => :diagnosis, :allow_nil => true, :prefix => true

	attr_protected( :study_subject_id, :study_subject )

	include PatientValidations

	#	Would it be better to do this before_validation?
	before_save :format_raf_zip, :if => :raf_zip_changed?

	after_save :trigger_update_matching_study_subjects_reference_date,
		:if => :admit_date_changed?

	after_save :trigger_setting_was_under_15_at_dx,
		:if => :admit_date_changed?

protected

	#	Simply squish the zip removing leading and trailing spaces.
	def format_raf_zip
		#	zip was nil during import and skipping validations
		self.raf_zip.squish! unless raf_zip.nil?
		# convert to 12345-1234
		if !self.raf_zip.nil? and self.raf_zip.length > 5
			old = self.raf_zip.gsub(/\D/,'')
			self.raf_zip = "#{old[0..4]}-#{old[5..8]}"
		end
	end

	def trigger_setting_was_under_15_at_dx
		logger.debug "DEBUG: calling update_patient_was_under_15_at_dx from Patient:#{self.attributes['id']}"
		logger.debug "DEBUG: Admit date changed from:#{admit_date_was}:to:#{admit_date}"
		if study_subject
			logger.debug "DEBUG: study_subject:#{study_subject.id}"
			study_subject.update_patient_was_under_15_at_dx
		else
			#	This should never happen, except in testing.
			logger.warn "WARNING: Patient(#{self.attributes['id']}) is missing study_subject"
		end
	end
#
#	logger levels are ... debug, info, warn, error, and fatal.
#
	def trigger_update_matching_study_subjects_reference_date
		logger.debug "DEBUG: calling update_study_subjects_reference_date_matching from Patient:#{self.attributes['id']}"
		logger.debug "DEBUG: Admit date changed from:#{admit_date_was}:to:#{admit_date}"
		if study_subject
			logger.debug "DEBUG: study_subject:#{study_subject.id}"
			# study_subject.update_matching_study_subjects_reference_date
			study_subject.update_study_subjects_reference_date_matching
		else
			#	This should never happen, except in testing.
			logger.warn "WARNING: Patient(#{self.attributes['id']}) is missing study_subject"
		end
	end

end
