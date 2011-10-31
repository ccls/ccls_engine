class CandidateControl < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#
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
		:birth_county, :birth_type, :mother_maiden_name,
		:rejection_reason, :maximum => 250, :allow_blank => true
		#	NEED :allow_blank => true or fails validation and says it too long (even when blank)
	validates_inclusion_of :sex, :in => %w( M F DK )

	#	Returns string containing candidates's first, middle and last name
	def full_name
		[first_name, middle_name, last_name].compact.join(' ')
	end

	def create_study_subjects(case_subject,grouping = '6')
		next_orderno = case_subject.next_control_orderno(grouping)

		#	Use a block so can assign all attributes without concern for attr_protected
		child_identifier = Identifier.new do |i|
			i.case_control_type  = grouping
			i.state_registrar_no = state_registrar_no
			i.local_registrar_no = local_registrar_no
			i.orderno            = next_orderno
			i.matchingid         = case_subject.identifier.subjectid
			i.patid              = case_subject.patid
		end

#	don't know if I should add it here or put it back in the Identifier model
#			i.studyid            = nil                #	TODO

#	I think that this may use the standard database transaction
#		ActiveRecord::Base.transaction do
#	Nested multi-database transactions probably do not exist.
		CandidateControl.transaction do

			child = StudySubject.create!({
				:subject_type => SubjectType['Control'],
				:vital_status => VitalStatus['living'],
				:mother_hispanicity_id => mother_hispanicity_id,
				:father_hispanicity_id => father_hispanicity_id,
				:birth_type            => birth_type,
				:mother_yrs_educ       => mother_yrs_educ,
				:father_yrs_educ       => father_yrs_educ,
				:birth_county          => birth_county,
				:hispanicity_id        => ( 
					( [mother_hispanicity_id,father_hispanicity_id].include?(1) ) ? 1 : nil ),
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
			child.assign_icf_master_id

			#	NOTE this may require passing info
			#	that is in the candidate_control record, but not in the child subject
			#		mother_hispanicity_id
			child.create_mother	#	({ .... })
	
			self.study_subject_id = child.id
			self.assigned_on = Date.today
			self.save!
		end
		self
	end

end
