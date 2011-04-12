# Patient related subject info.
class Patient < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :organization
	belongs_to :diagnosis

	validates_presence_of   :study_subject_id
	validates_presence_of   :subject
	validates_uniqueness_of :study_subject_id

	validates_past_date_for :admit_date
	validates_past_date_for :diagnosis_date
	validate :admit_date_is_after_dob
	validate :diagnosis_date_is_after_dob
	validate :subject_is_case

	validates_complete_date_for :admit_date,
		:allow_nil => true
	validates_complete_date_for :diagnosis_date,
		:allow_nil => true

	after_save :update_matching_subjects_reference_date,
		:if => :admit_date_changed?

protected

	def admit_date_is_after_dob
		if !admit_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			admit_date < subject.dob
			errors.add(:admit_date, "is before subject's dob.") 
		end
	end

	def diagnosis_date_is_after_dob
		if !diagnosis_date.blank? && 
			!subject.blank? && 
			!subject.dob.blank? && 
			diagnosis_date < subject.dob
			errors.add(:diagnosis_date, "is before subject's dob.") 
		end
	end

	def subject_is_case
		if subject and subject.subject_type.code != 'Case'
		errors.add(:subject,"must be case to have patient info")
		end
	end

	def update_matching_subjects_reference_date
		#	puts "update_matching_subjects_reference_date"
		#	puts "admit_date was:#{admit_date}"
		#	puts "admit_date is:#{admit_date}"
		#	puts "matchingid is blank (FYI)" if subject.try(:identifier).try(:matchingid).blank?
		unless subject.try(:identifier).try(:matchingid).blank?
			Subject.update_all({:reference_date => admit_date },
				['identifiers.matchingid = ?',subject.identifier.matchingid],
				{ :joins => :identifier })
		end
	end

end
