class CandidateControl < Shared
	belongs_to :study_subject

	attr_protected :study_subject_id

#	validates_presence_of   :key, :code, :description
#	validates_presence_of   :reject_candidate	#	fails if value is actually false
	validates_inclusion_of  :reject_candidate, :in => [true, false]
#	validates_uniqueness_of :key, :code, :description

#	Why is this 5?  It should be 4.
#	validates_length_of     :related_patid, :is => 5, :allow_blank => true
	validates_length_of     :related_patid, :is => 4, :allow_blank => true

	validates_length_of     :state_registrar_no, :local_registrar_no, 
		:maximum => 25, :allow_blank => true
	#	NEED :allow_blank => true or fails validation and says it too long (even when blank)

	validates_length_of     :first_name, :middle_name, :last_name,
		:sex, :birth_county, :birth_type, :mother_maiden_name,
		:rejection_reason, :maximum => 250, :allow_blank => true
	#	NEED :allow_blank => true or fails validation and says it too long (even when blank)

#			t.integer :icf_master_id
#			t.string  :related_patid, :limit => 5
#			t.integer :study_subject_id
#			t.string  :first_name
#			t.string  :middle_name
#			t.string  :last_name
#			t.date    :dob
#			t.string  :state_registrar_no, :limit => 25
#			t.string  :local_registrar_no, :limit => 25
#			t.string  :sex
#			t.string  :birth_county
#			t.date    :assigned_on
#			t.integer :mother_race_id
#			t.integer :mother_hispanicity_id
#			t.integer :father_hispanicity_id
#			t.integer :father_race_id
#			t.string  :birth_type
#			t.string  :mother_maiden_name
#			t.integer :mother_yrs_educ
#			t.integer :father_yrs_educ
#			t.boolean :reject_candidate, :null => false, :default => false
#			t.string  :rejection_reason

	validates_presence_of :rejection_reason, :if => :reject_candidate


	def create_study_subjects(case_subject)
		#	do it this way so can set protected attributes
		child_identifier = Identifier.new({
			:case_control_type  => '6',
			:state_registrar_no => state_registrar_no,
			:local_registrar_no => local_registrar_no,
			:orderno            => nil,                #	TODO	attr_protected
			:matchingid         => case_subject.identifier.subjectid,
			:studyid            => nil,                #	TODO	attr_protected
			:icf_master_id      => nil                 #	TODO	attr_protected
		})
		child_identifier.patid = case_subject.patid

		child = StudySubject.create!({
			:subject_type => SubjectType['Control'],
			:vital_status => VitalStatus['living'],
			:mother_hispanicity_id => mother_hispanicity_id,
			:father_hispanicity_id => father_hispanicity_id,
			:birth_type            => birth_type,
			:mother_yrs_educ       => mother_yrs_educ,
			:father_yrs_educ       => father_yrs_educ,
			:birth_county          => birth_county,
			:hispanicity_id        => 0,              #	TODO
			:pii_attributes => {
				:first_name  => ( first_name  || 'TEST' ),
				:middle_name => ( middle_name || 'TEST' ),
				:last_name   => ( last_name   || 'TEST' ),
				:dob         => ( dob         || Date.today ),
				:mother_maiden_name => mother_maiden_name,
				:mother_race_id     => mother_race_id,
				:father_race_id     => father_race_id
			},
			:identifier => child_identifier,
			:enrollments_attributes => [{
				:project => Project['phase5']
			}]
		})

		#	do it this way so can set protected attributes
		mother_identifier = Identifier.new({
			:case_control_type => 'M',				#	NOTE Can't really do this.  Need to allow nil
			:matchingid        => case_subject.identifier.subjectid,
#			:studyid           => nil,                #	TODO	attr_protected
			:icf_master_id     => nil                 #	TODO	attr_protected
		})
		mother_identifier.familyid = child.identifier.familyid
		mother = StudySubject.create!({
			:subject_type => SubjectType['Mother'],
			:vital_status => VitalStatus['living'],
			:sex => 'F',			#	TODO M/F or male/female? have to check.
			:hispanicity_id => mother_hispanicity_id,
			:pii_attributes => {
				:first_name  => 'TEST',
				:middle_name => 'TEST',
				:last_name   => 'TEST',
				:mother_maiden_name => mother_maiden_name,	#	NOTE this is a misnomer as this is the mother
				:dob         => Date.today
			},
			:identifier => mother_identifier
		})
		self.study_subject_id = child.id
		self.assigned_on = Date.today
		self
	end

end
