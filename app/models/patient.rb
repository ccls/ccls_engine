# Patient related subject info.
class Patient < Shared

	belongs_to :subject, :foreign_key => 'study_subject_id'

	belongs_to :organization
	belongs_to :diagnosis

	##	TODO - find a way to do this
	# because subject accepts_nested_attributes for pii 
	# we can't require study_subject_id on create
	#
	#	study_subject_id is not known until before_save
	#		so cannot be validated on creation
	#
	attr_protected :study_subject_id
	validates_presence_of   :subject,          :on => :update
	validates_uniqueness_of :study_subject_id, :allow_nil => true

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
	before_create :ensure_presence_and_uniqueness_of_study_subject_id

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

#	TODO again, perhaps replace the inline regex with a method that returns it
	validates_format_of :raf_zip,
		:with => /\A\s*\d{5}(-)?(\d{4})?\s*\z/,
		:message => "should be 12345 or 12345-1234"

	#	TODO it would probably be better to do this before_validation
	before_save :format_zip

	after_save :trigger_update_matching_subjects_reference_date,
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
		subject.update_patient_was_under_15_at_dx
	end

	def trigger_update_matching_subjects_reference_date
#		puts "triggering_update_matching_subjects_reference_date from Patient"
#		puts "Admit date changed from:#{admit_date_was}:to:#{admit_date}"
#		subject.update_matching_subjects_reference_date
		subject.update_subjects_reference_date_matching
	end

	##
	#	since I can't use the conventional validations to check 
	#	study_subject_id, do it before_save.  This'll rollback 
	#	the subject creation too if using nested attributes.
	def ensure_presence_and_uniqueness_of_study_subject_id
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
	#	the subject has not been resolved yet, unless this is an update.
	#	This results in a similar validation in Subject.
	def admit_date_is_after_dob
		if !admit_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			admit_date < subject.dob
			errors.add(:admit_date, "is before subject's dob.") 
		end
	end

	##
	#	This validation does not work when using nested attributes as 
	#	the subject has not been resolved yet, unless this is an update.
	#	This results in a similar validation in Subject.
	def diagnosis_date_is_after_dob
		if !diagnosis_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			diagnosis_date < subject.dob
			errors.add(:diagnosis_date, "is before subject's dob.") 
		end
	end

	##
	#	This validation does not work when using nested attributes as 
	#	the subject has not been resolved yet, unless this is an update.
	#	This results in a similar validation in Subject.
	def subject_is_case
		if subject and subject.subject_type.code != 'Case'
			errors.add(:subject,"must be case to have patient info")
		end
	end

#	#	TODO
#	#	Move this functionality into Subject
#	#		Trigger from patient#after_save if admit_date changed?
#	#		Trigger from identifier#after_save if matchingid changed for was* and current?
#	#
#		def update_matching_subjects_reference_date
#	#	TODO doubt that this really works since subject probably hasn't been resolved yet
#	#			if using nested_attributes
#			#	puts "update_matching_subjects_reference_date"
#			#	puts "admit_date was:#{admit_date}"
#			#	puts "admit_date is:#{admit_date}"
#			#	puts "matchingid is blank (FYI)" if subject.try(:identifier).try(:matchingid).blank?
#			unless subject.try(:identifier).try(:matchingid).blank?
#				Subject.ccls_update_all({:reference_date => admit_date },
#					['identifiers.matchingid = ?',subject.identifier.matchingid],
#					{ :joins => :identifier })
#			end
#		end

end
