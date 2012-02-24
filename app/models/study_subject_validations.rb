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
#	validates_inclusion_of :sex, :in => %w( M F DK ), :allow_blank => true
	validates_inclusion_of :sex, :in => valid_sex_values, :allow_blank => true
	validates_inclusion_of :do_not_contact, :in => [ true, false ]

	validates_complete_date_for :reference_date, :allow_nil => true

	validate :presence_of_dob, :unless => :is_mother?
	validates_complete_date_for :dob,     :allow_nil => true
	validates_complete_date_for :died_on, :allow_nil => true
	validates_uniqueness_of     :email, :icf_master_id, :state_id_no, 
		:state_registrar_no, :local_registrar_no, :gbid, :lab_no_wiemels, 
		:accession_no, :idno_wiemels, :studyid, :allow_nil => true

	validates_format_of :email,
	  :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, 
		:allow_blank => true

	validate :presence_of_guardian_relationship_other,
		:if => :guardian_relationship_is_other?

	validates_presence_of :birth_city,
		:if => :birth_country_is_united_states?
	validates_presence_of :birth_state,
		:if => :birth_country_is_united_states?

	validates_length_of :case_control_type, :is => 1, :allow_nil => true

	validates_length_of     :ssn, :maximum => 250, :allow_nil => true
	validates_uniqueness_of :ssn, :allow_nil => true
	validates_format_of     :ssn, :with => /\A\d{3}-\d{2}-\d{4}\z/,
		:message => "should be formatted ###-##-####", :allow_nil => true

 	validates_length_of :birth_year, 
			:maximum => 4, :allow_blank => true
	validates_length_of :newid, 
			:maximum => 6, :allow_blank => true
	validates_length_of :icf_master_id, 
			:maximum => 9, :allow_blank => true
	validates_length_of :childidwho, :idno_wiemels, 
 		:generational_suffix, :father_generational_suffix, 
			:maximum => 10, :allow_blank => true
	validates_length_of :lab_no_wiemels, :accession_no, 
			:maximum => 25, :allow_blank => true
	validates_length_of :gbid, 
			:maximum => 26, :allow_blank => true
	validates_length_of :first_name, :last_name, 
		:middle_name, :maiden_name, :guardian_relationship_other,
		:father_first_name, :father_middle_name, :father_last_name,
		:mother_first_name, :mother_middle_name, :mother_maiden_name, :mother_last_name,
		:guardian_first_name, :guardian_middle_name, :guardian_last_name,
		:mother_race_other, :father_race_other,
		:birth_city, :birth_state, :birth_country,
		:state_id_no, :state_registrar_no, :local_registrar_no,
		:lab_no, :related_childid, :related_case_childid,
			:maximum => 250, :allow_blank => true

	# custom validation for custom message without standard attribute prefix
	def presence_of_sex
		if sex.blank?
			errors.add(:sex, ActiveRecord::Error.new(
				self, :base, :blank, {
					:message => "No sex has been chosen." } ) )
		end
	end

protected

	def birth_country_is_united_states?
		birth_country == 'United States'
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

end	#	class_eval
end	#	included
end	#	StudySubjectValidations

__END__

