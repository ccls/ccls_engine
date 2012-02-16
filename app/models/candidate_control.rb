class CandidateControl < ActiveRecordShared

	belongs_to :study_subject

	validates_presence_of  :first_name
	validates_presence_of  :last_name
	validates_presence_of  :dob
	validates_inclusion_of :reject_candidate, :in => [true, false]
	validates_presence_of  :rejection_reason, :if => :reject_candidate
	validates_length_of    :related_patid, :is => 4, :allow_blank => true
	validates_length_of    :state_registrar_no, :maximum => 25, :allow_blank => true
	validates_length_of    :local_registrar_no, :maximum => 25, :allow_blank => true

	validates_length_of    :first_name, :middle_name, :last_name,
		:birth_county, :birth_type, :mother_maiden_name,
		:rejection_reason, :maximum => 250, :allow_blank => true

	validates_inclusion_of :sex, :in => %w( M F DK )

	#	Returns string containing candidates's first, middle and last name
	def full_name
		[first_name, middle_name, last_name].delete_if(&:blank?).join(' ')
	end

	#	Returns string containing candidates's mother's first, middle and last name
	def mother_full_name
		[mother_first_name, mother_middle_name, mother_last_name].delete_if(&:blank?).join(' ')
	end

	def create_study_subjects(case_subject,grouping = '6')
		next_orderno = case_subject.next_control_orderno(grouping)

#		#	Use a block so can assign all attributes without concern for attr_protected
#		child_identifier = Identifier.new do |i|
#			i.case_control_type  = grouping
#			i.state_registrar_no = state_registrar_no
#			i.local_registrar_no = local_registrar_no
#			i.orderno            = next_orderno
#			i.matchingid         = case_subject.identifier.subjectid
#			i.patid              = case_subject.patid
#		end

		CandidateControl.transaction do

#			child = StudySubject.create!({
			child = StudySubject.new do |s|
				s.subject_type = SubjectType['Control']
				s.vital_status = VitalStatus['living']
				s.sex                   = sex
				s.mom_is_biomom         = mom_is_biomom
				s.dad_is_biodad         = dad_is_biodad
				s.mother_hispanicity_id = mother_hispanicity_id
				s.father_hispanicity_id = father_hispanicity_id
				s.birth_type            = birth_type
				s.mother_yrs_educ       = mother_yrs_educ
				s.father_yrs_educ       = father_yrs_educ
				s.birth_county          = birth_county
				s.hispanicity_id        = ( 
					( [mother_hispanicity_id,father_hispanicity_id].include?(1) ) ? 1 : nil )
				s.first_name         = first_name
				s.middle_name        = middle_name
				s.last_name          = last_name
				s.dob                = dob
				s.mother_first_name  = mother_first_name
				s.mother_middle_name = mother_middle_name
				s.mother_last_name   = mother_last_name
				s.mother_maiden_name = mother_maiden_name
				s.mother_race_id     = mother_race_id
				s.father_race_id     = father_race_id

				s.case_control_type  = grouping
				s.state_registrar_no = state_registrar_no
				s.local_registrar_no = local_registrar_no
				s.orderno            = next_orderno
#				s.matchingid         = case_subject.identifier.subjectid
				s.matchingid         = case_subject.subjectid
				s.patid              = case_subject.patid
			end
			child.save!

#			child = StudySubject.create!({
#				:subject_type => SubjectType['Control'],
#				:vital_status => VitalStatus['living'],
#				:sex                   => sex,
#				:mom_is_biomom         => mom_is_biomom,
#				:dad_is_biodad         => dad_is_biodad,
#				:mother_hispanicity_id => mother_hispanicity_id,
#				:father_hispanicity_id => father_hispanicity_id,
#				:birth_type            => birth_type,
#				:mother_yrs_educ       => mother_yrs_educ,
#				:father_yrs_educ       => father_yrs_educ,
#				:birth_county          => birth_county,
#				:hispanicity_id        => ( 
#					( [mother_hispanicity_id,father_hispanicity_id].include?(1) ) ? 1 : nil ),
##				:pii_attributes => {
#					:first_name         => first_name,
#					:middle_name        => middle_name,
#					:last_name          => last_name,
#					:dob                => dob,
#					:mother_first_name  => mother_first_name,
#					:mother_middle_name => mother_middle_name,
#					:mother_last_name   => mother_last_name,
#					:mother_maiden_name => mother_maiden_name,
#					:mother_race_id     => mother_race_id,
#					:father_race_id     => father_race_id,
##				},
#				:identifier => child_identifier
#			})
#	not necessary as ccls enrollment is created in subject
#				:enrollments_attributes => [{
#					:project => Project['ccls']
#				}],

#	possibly put in a identifier#after_create ???
#	or study_subject#after_create ???
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
