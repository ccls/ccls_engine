#	==	requires
#	*	subject_type_id
class StudySubject < ActiveRecordShared

	class NotTwoAbstracts < StandardError; end
	class DuplicatesFound < StandardError; end

	#	This is purely an attempt at organization.
	#	Initially, this was by purpose, but now modifying to
	#	be by association or topic as this seems more logical.
	#	Also trying to map this same organization in the tests
	#	so that autotest triggers the more likely effected tests.
	include StudySubjectAssociations
	include StudySubjectValidations

	include StudySubjectPatient
	include StudySubjectPii
	include StudySubjectIdentifier
	include StudySubjectDuplicates
	include StudySubjectAbstracts
	include StudySubjectRaces
	include StudySubjectLanguages
	include StudySubjectAddresses

	#	Declaration order matters. 
	#	OperationalEvents are through Enrollments.
	include StudySubjectEnrollments
	include StudySubjectOperationalEvents

	include StudySubjectHomexOutcome
	include StudySubjectInterviews

	delegate :is_other?, :to => :guardian_relationship, 
		:allow_nil => true, :prefix => true 

	#	can lead to multiple piis in db for study_subject
	#	if not done correctly
	#	s.update_attributes({"pii_attributes" => { "ssn" => "123456789", 'state_id_no' => 'x'}})
	#	s.update_attributes({"pii_attributes" => { "ssn" => "987654321", 'state_id_no' => 'a'}})
	#	Pii.find(:all, :conditions => {:study_subject_id => s.id }).count 
	#	=> 2
	#	without the :id attribute, it will create, but NOT destroy
	#	s.reload.pii  will return the first one (sorts by id)
	#	s.pii.destroy will destroy the last one !?!?!?
	#	Make all these require a unique study_subject_id
	#	Newer versions of rails actually nullify the old record

	accepts_nested_attributes_for :phone_numbers,
		:reject_if => proc { |attrs| attrs[:phone_number].blank? }
	accepts_nested_attributes_for :gift_cards

	#	Find the case or control subject with matching familyid except self.
	def child
		if (subject_type_id == self.class.subject_type_mother_id) && !familyid.blank?
			self.class.find(:first,
				:include => [:subject_type],
				:conditions => [
					"study_subjects.id != ? AND subjectid = ? AND subject_type_id IN (?)", 
						id, familyid, 
						[self.class.subject_type_case_id,self.class.subject_type_control_id] ]
			)
		else
			nil
		end
	end

	#	Find the subject with matching familyid and subject_type of Mother.
	def mother
		return nil if familyid.blank?
		self.class.find(:first,
			:include => [:subject_type],
			:conditions => { 
				:familyid        => familyid,
				:subject_type_id => self.class.subject_type_mother_id
			}
		)
	end

	#	Find all the subjects with matching familyid except self.
	def family
		return [] if familyid.blank?
		self.class.find(:all,
			:include => [:subject_type],
			:conditions => [
				"study_subjects.id != ? AND familyid = ?", id, familyid ]
		)
	end

	#	Find all the subjects with matching matchingid except self.
	def matching
		return [] if matchingid.blank?
		self.class.find(:all,
			:include => [:subject_type],
			:conditions => [
				"study_subjects.id != ? AND matchingid = ?", 
					id, matchingid ]
		)
	end

	#	Find all the subjects with matching patid with subject_type Control except self.
	#	If patid is nil, this sql doesn't work.  
	#			TODO Could fix, but this situation is unlikely.
	def controls
		return [] unless is_case?
		self.class.find(:all, 
			:include => [:subject_type],
			:conditions => [
				"study_subjects.id != ? AND patid = ? AND subject_type_id = ?", 
					id, patid, self.class.subject_type_control_id ] 
		)
	end

	def rejected_controls
		return [] unless is_case?
		CandidateControl.find(:all,
			:conditions => {
				:related_patid    => patid,
				:reject_candidate => true
			}
		)
	end

	def to_s
		[childid,'(',studyid,full_name,')'].compact.join(' ')
	end

	#	Returns boolean of comparison
	#	true only if type is Case
	def is_case?
		subject_type_id == self.class.subject_type_case_id
	end

	#	Returns boolean of comparison
	#	true only if type is Control
	def is_control?
		subject_type_id == self.class.subject_type_control_id
	end

	#	Returns boolean of comparison
	#	true only if type is Mother
	def is_mother?
		subject_type_id == self.class.subject_type_mother_id
	end

	def self.search(params={})
		StudySubjectSearch.new(params).study_subjects
	end

	#	Create (or just return mother) a mother subject based on subject's own data.
	def create_mother
		return self if is_mother?
		#	The mother method will effectively find and itself.
		existing_mother = mother
		if existing_mother
			existing_mother
		else
			new_mother = self.class.new do |s|
				s.subject_type_id = self.class.subject_type_mother_id
				s.vital_status_id = VitalStatus['living'].id
				s.sex = 'F'
				s.hispanicity_id = mother_hispanicity_id
				s.first_name  = mother_first_name
				s.middle_name = mother_middle_name
				s.last_name   = mother_last_name
				s.maiden_name = mother_maiden_name

				#	protected attributes!
				s.matchingid = matchingid
				s.familyid   = familyid
			end
			new_mother.save!
			new_mother.assign_icf_master_id
			new_mother
		end
	end

	def assign_icf_master_id
		if icf_master_id.blank?
			next_icf_master_id = IcfMasterId.next_unused
			if next_icf_master_id
				self.update_attribute(:icf_master_id, next_icf_master_id.to_s)
				next_icf_master_id.study_subject = self
				next_icf_master_id.assigned_on   = Date.today
				next_icf_master_id.save!
			end
		end
		self
	end

	def next_control_orderno(grouping='6')
		return nil unless is_case?
		last_control = self.class.find(:first, 
			:order => 'orderno DESC', 
			:conditions => { 
				:subject_type_id   => self.class.subject_type_control_id,
				:case_control_type => grouping,
				:matchingid        => self.subjectid
			}
		)
		( last_control.try(:orderno) || 0 ) + 1
	end

	def self.find_case_by_patid(patid)
		self.find(:first,	#	patid is unique so better only be 1
			:conditions => [
				'subject_type_id = ? AND patid = ?',
				subject_type_case_id, patid
			]
		)
	end

	def icf_master_id_to_s
		( icf_master_id.blank? ) ?  "[no ID assigned]" : icf_master_id
	end

	def childid_to_s
		( is_mother? ) ? "#{child.try(:childid)} (mother)" : childid
	end

	def studyid_to_s
		( is_mother? ) ? "n/a" : studyid
	end

protected

	#	Use these to stop the constant checking.
	def self.subject_type_mother_id
		@@subject_type_mother_id ||= SubjectType['Mother'].id
	end
	def self.subject_type_control_id
		@@subject_type_control_id ||= SubjectType['Control'].id
	end
	def self.subject_type_case_id
		@@subject_type_case_id ||= SubjectType['Case'].id
	end

end
