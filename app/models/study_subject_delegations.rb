#
#	Simply extracted some code to clean up model.
#	I'd like to do this to all of the really big classes
#	but let's see how this goes first.
#
module StudySubjectDelegations
def self.included(base)
#	Must delay the calls to these ActiveRecord methods
#	or it will raise many "undefined method"s.
base.class_eval do

	with_options :allow_nil => true do |n|
		n.with_options :to => :patient do |o|
			o.delegate :admit_date
			o.delegate :organization
			o.delegate :organization_id
			o.delegate :hospital_no
		end
		n.with_options :to => :pii do |o|
			o.delegate :initials
			o.delegate :email
			o.delegate :first_name
			o.delegate :middle_name
			o.delegate :last_name
			o.delegate :maiden_name
			o.delegate :dob
			o.delegate :fathers_name
			o.delegate :father_first_name
			o.delegate :father_middle_name
			o.delegate :father_last_name
			o.delegate :mothers_name
			o.delegate :mother_first_name
			o.delegate :mother_middle_name
			o.delegate :mother_last_name
			o.delegate :mother_maiden_name
		end
		n.with_options :to => :identifier do |o|
			o.delegate :state_id_no
			o.delegate :state_registrar_no
			o.delegate :local_registrar_no
			o.delegate :ssn
			o.delegate :patid
			o.delegate :orderno
			o.delegate :case_control_type
			o.delegate :subjectid
#			o.delegate :familyid
#			o.delegate :matchingid
		end
		n.with_options :to => :homex_outcome do |o|
			o.delegate :interview_outcome
			o.delegate :interview_outcome_on
			o.delegate :sample_outcome
			o.delegate :sample_outcome_on
		end
	end

end	#	class_eval
end	#	included
end	#	StudySubjectDelegations
