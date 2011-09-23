class CandidateControl < Shared
	belongs_to :study_subject

	attr_protected :study_subject_id

	validates_presence_of   :first_name, :last_name, :dob
	validates_inclusion_of  :reject_candidate, :in => [true, false]
	validates_presence_of   :rejection_reason, :if => :reject_candidate
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



	def create_study_subjects(case_subject)
		#	Use a block so can assign all attributes without concern for attr_protected
		child_identifier = Identifier.new do |i|
			i.case_control_type  = '6'
			i.state_registrar_no = state_registrar_no
			i.local_registrar_no = local_registrar_no
			i.orderno            = nil                #	TODO
			i.matchingid         = case_subject.identifier.subjectid
			i.icf_master_id      = nil                #	TODO
			i.patid              = case_subject.patid
		end
#	can't assign the studyid as don't have the orderno YET
#	don't know if I should add it here or put it back in the Identifier model
#			i.studyid            = nil                #	TODO

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
				:first_name         => first_name,
				:middle_name        => middle_name,
				:last_name          => last_name,
				:dob                => dob,
				:mother_maiden_name => mother_maiden_name,
				:mother_race_id     => mother_race_id,
				:father_race_id     => father_race_id
			},
			:identifier => child_identifier,
			:enrollments_attributes => [{
				:project => Project['phase5']
			}]
		})

		#	Use a block so can assign all attributes without concern for attr_protected
		mother_identifier = Identifier.new do |i|
			i.matchingid    = case_subject.identifier.subjectid
			i.icf_master_id = nil                #	TODO
			i.familyid      = child.identifier.familyid
		end
#			i.studyid           = nil                #	TODO	#	mother's don't really have a valid studyid
#			i.case_control_type = 'M'				#	NOTE Can't really do this.  Need to allow nil

		mother = StudySubject.create!({
			:subject_type => SubjectType['Mother'],
			:vital_status => VitalStatus['living'],
			:sex => 'F',			#	TODO M/F or male/female? have to check.
			:hispanicity_id => mother_hispanicity_id,
#			:pii_attributes => {
#				:first_name  => 'TEST',
#				:middle_name => 'TEST',
#				:last_name   => 'TEST',
#				:mother_maiden_name => mother_maiden_name,	#	NOTE this is a misnomer as this is the mother
#				:dob         => Date.today
#			},
			:identifier => mother_identifier
		})
		self.study_subject_id = child.id
		self.assigned_on = Date.today
		self
	end

end
