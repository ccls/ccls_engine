#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectValidations
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	validates_presence_of :subject_type_id
	validates_presence_of :subject_type, :if => :subject_type_id

	validate :presence_of_sex
	validates_inclusion_of :sex, :in => %w( M F DK ), :allow_blank => true
	validates_inclusion_of :do_not_contact, :in => [ true, false ]

	validate :must_be_case_if_patient
	validate :patient_admit_date_is_after_dob
	validate :patient_diagnosis_date_is_after_dob
	validates_complete_date_for :reference_date, :allow_nil => true


	#	This is a duplication of a patient validation that won't
	#	work if using nested attributes.  Don't like doing this.
	def patient_admit_date_is_after_dob
#		if !patient.nil? && !patient.admit_date.blank? && 
#			!pii.nil? && !pii.dob.blank? && patient.admit_date < pii.dob &&
#			pii.dob.to_date != Date.parse('1/1/1900') &&
		if !patient.nil? && !patient.admit_date.blank? && 
			!dob.blank? && patient.admit_date < dob &&
			dob.to_date != Date.parse('1/1/1900') &&
			patient.admit_date.to_date != Date.parse('1/1/1900')
			errors.add('patient:admit_date', "is before study_subject's dob.") 
		end
	end

	#	This is a duplication of a patient validation that won't
	#	work if using nested attributes.  Don't like doing this.
	def patient_diagnosis_date_is_after_dob
		if !patient.nil? && !patient.diagnosis_date.blank? && 
			!dob.blank? && patient.diagnosis_date < dob
#			!pii.nil? && !pii.dob.blank? && patient.diagnosis_date < pii.dob
			errors.add('patient:diagnosis_date', "is before study_subject's dob.") 
		end
	end

	def must_be_case_if_patient
		if !patient.nil? and !is_case?
			errors.add(:patient ,"must be case to have patient info")
		end
	end

	# custom validation for custom message without standard attribute prefix
	def presence_of_sex
		if sex.blank?
			errors.add(:sex, ActiveRecord::Error.new(
				self, :base, :blank, {
					:message => "No sex has been chosen." } ) )
		end
	end

end	#	class_eval
end	#	included
end	#	StudySubjectValidations
