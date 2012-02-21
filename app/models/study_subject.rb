#	==	requires
#	*	subject_type_id
class StudySubject < ActiveRecordShared

	class NotTwoAbstracts < StandardError; end
	class DuplicatesFound < StandardError; end

	include StudySubjectAssociations
	include StudySubjectCallbacks
	include StudySubjectValidations
	include StudySubjectDelegations
	include StudySubjectPii
	include StudySubjectIdentifier


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

	accepts_nested_attributes_for :enrollments
	accepts_nested_attributes_for :addressings,
		:reject_if => proc { |attrs|
			!attrs[:address_required] &&
			attrs[:address_attributes][:line_1].blank? &&
			attrs[:address_attributes][:line_2].blank? &&
			attrs[:address_attributes][:unit].blank? &&
			attrs[:address_attributes][:city].blank? &&
			attrs[:address_attributes][:zip].blank? &&
			attrs[:address_attributes][:county].blank?
		}
	accepts_nested_attributes_for :phone_numbers,
		:reject_if => proc { |attrs| attrs[:phone_number].blank? }
	accepts_nested_attributes_for :gift_cards
	accepts_nested_attributes_for :subject_races, 
		:allow_destroy => true,
		:reject_if => proc{|attributes| attributes['race_id'].blank? }
	accepts_nested_attributes_for :subject_languages, 
		:allow_destroy => true,
		:reject_if => proc{|attributes| attributes['language_id'].blank? }
	accepts_nested_attributes_for :homex_outcome
	accepts_nested_attributes_for :patient


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
#	TODO what if familyid is NULL?
#		return nil if familyid.blank?
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

	#	Returns number of addresses with 
	#	address_type.code == 'residence'
	def residence_addresses_count
		addresses.count(:conditions => { :address_type_id => AddressType['residence'].id })
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

	def race_names
		races.collect(&:to_s).join(', ')
	end

	#	Returns home exposures interview
	def hx_interview
		interviews.find(:first,
			:conditions => "projects.code = 'HomeExposures'",
			:joins => [:instrument_version => [:instrument => :project]]
		)
	end

	def is_eligible_for_invitation?
		!self.email.blank?
	end

	def self.search(params={})
		StudySubjectSearch.new(params).study_subjects
	end

	def abstracts_the_same?
		raise StudySubject::NotTwoAbstracts unless abstracts_count == 2
		#	abstracts.inject(:is_the_same_as?) was nice
		#	but using inject is ruby >= 1.8.7
		return abstracts[0].is_the_same_as?(abstracts[1])
	end

	def abstract_diffs
		raise StudySubject::NotTwoAbstracts unless abstracts_count == 2
		#	abstracts.inject(:diff) was nice
		#	but using inject is ruby >= 1.8.7
		return abstracts[0].diff(abstracts[1])
	end

	#	Create (or just return mother) a mother subject based on subject's own data.
	def create_mother
		#	The mother method will effectively find and itself.
		existing_mother = mother
		if existing_mother
			existing_mother
		else
#			new_mother = StudySubject.new do |s|
			new_mother = self.class.new do |s|
#				s.subject_type_id = StudySubject.subject_type_mother_id
				s.subject_type_id = self.class.subject_type_mother_id
				s.vital_status_id = VitalStatus['living'].id
				s.sex = 'F'			#	TODO M/F or male/female? have to check.
#				s.hispanicity_id = mother_hispanicity_id	#	TODO where from? 
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
#		last_control = StudySubject.find(:first, 
		last_control = self.class.find(:first, 
			:order => 'orderno DESC', 
			:conditions => { 
#				:subject_type_id => StudySubject.subject_type_control_id,
#				'case_control_type' => grouping,
#				'matchingid' => self.subjectid
				:subject_type_id => self.class.subject_type_control_id,
				:case_control_type => grouping,
				:matchingid => self.subjectid
			}
		)
		( last_control.try(:orderno) || 0 ) + 1
	end

	#
	#	Basically this is just a custom search expecting only the 
	#	following possible params for search / comparison ...
	#
	#		mother_maiden_name
	#		hospital_no
	#		dob
	#		sex
	#		admit_date
	#		organization_id
	#
	#		Would want to explicitly exclude self, but this check is
	#		to be done BEFORE subject creation so won't actually
	#		have an id to use to exclude itself anyway.
	#
	#		For adding controls, will need to be able to exclude case
	#		so adding :exclude_id option somehow
	#
	def self.duplicates(params={})
		conditions = [[],{}]

		if params.has_key?(:hospital_no) and !params[:hospital_no].blank?
			conditions[0] << '(hospital_no = :hospital_no)'
			conditions[1][:hospital_no] = params[:hospital_no]
		end

		#	This is effectively the only test for adding controls
		#	as the other attributes are from the patient model
		#	which is only for cases.
		if params.has_key?(:dob) and !params[:dob].blank? and
				params.has_key?(:sex) and !params[:sex].blank? and 
				params.has_key?(:mother_maiden_name)
#	since remove nullify of name fields, added comparison to ""
			conditions[0] << '(dob = :dob AND sex = :sex AND ( mother_maiden_name IS NULL OR mother_maiden_name = "" OR mother_maiden_name = :mother_maiden_name ))'
			conditions[1][:dob] = params[:dob]
			conditions[1][:sex] = params[:sex]
			#	added to_s as may be null so sql is valid and has '' rather than a blank
			conditions[1][:mother_maiden_name] = params[:mother_maiden_name].to_s		
		end
		if params.has_key?(:admit_date) and !params[:admit_date].blank? and
				params.has_key?(:organization_id) and !params[:organization_id].blank?
			conditions[0] << '(admit_date = :admit AND organization_id = :org)'
			conditions[1][:admit] = params[:admit_date]
			conditions[1][:org] = params[:organization_id]
		end

		unless conditions[0].blank?
			conditions_array = [ "(#{conditions[0].join(' OR ')})" ]
			if params.has_key?(:exclude_id)
				conditions_array[0] << " AND study_subjects.id != :exclude_id"
				conditions[1][:exclude_id] = params[:exclude_id]
			end
			conditions_array << conditions[1]
#puts conditions_array.inspect
#["((hospital_no = :hospital_no) OR (dob = :dob AND sex = :sex AND ( mother_maiden_name IS NULL OR mother_maiden_name = :mother_maiden_name )) OR (admit_date = :admit AND organization_id = :org)) AND study_subjects.id != :exclude_id", {:hospital_no=>"matchthis", :org=>31, :admit=>Wed, 16 Nov 2011, :sex=>"F", :exclude_id=>3, :mother_maiden_name=>"", :dob=>Wed, 16 Nov 2011}]

			find(:all,
				#	have to do a LEFT JOIN, not the default INNER JOIN, here
				#			:joins => [:pii,:patient,:identifier]
				#	otherwise would only include subjects with pii, patient and identifier,
				#	which would effectively exclude controls. (maybe that's ok?. NOT OK.)
				:joins => [
					'LEFT JOIN patients ON study_subjects.id = patients.study_subject_id'
				],
				:conditions => conditions_array
			) 
		else
			[]
		end
	end

	def duplicates(options={})
#		StudySubject.duplicates({
		self.class.duplicates({
			:mother_maiden_name => self.mother_maiden_name,
			:hospital_no => self.hospital_no,
			:dob => self.dob,
			:sex => self.sex,
			:admit_date => self.admit_date,
			:organization_id => self.organization_id
		}.merge(options))
	end

	def self.find_case_by_patid(patid)
#		StudySubject.find(:first,	#	patid is unique so better only be 1
#		self.class.find(:first,	#	patid is unique so better only be 1
		self.find(:first,	#	patid is unique so better only be 1
			:conditions => [
				'study_subjects.subject_type_id = ? AND patid = ?',
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

	def admitting_oncologist
		#	can be blank so need more than try unless I nilify admitting_oncologist if blank
		#patient.try(:admitting_oncologist) || "[no oncologist specified]"
		if patient and !patient.admitting_oncologist.blank?
			patient.admitting_oncologist
		else
			"[no oncologist specified]"
		end
	end

	def raf_duplicate_creation_attempted(attempted_subject)
		ccls_enrollment = enrollments.find_or_create_by_project_id(Project['ccls'].id)
		OperationalEvent.create!(
			:enrollment => ccls_enrollment,
			:operational_event_type => OperationalEventType['DuplicateCase'],
			:occurred_on            => Date.today,
			:description            => "a new RAF for this subject was submitted by " <<
				"#{attempted_subject.admitting_oncologist} of " <<
				"#{attempted_subject.organization} " <<
				"with hospital number: " <<
				"#{attempted_subject.hospital_no}."
		)
	end

#	operational_events.occurred_on where operational_event_type_id = 26 and enrollment_id is for any open project (where projects.ended_on is null) for study_subject_id

	def screener_complete_date_for_open_project
		OperationalEvent.find(:first,
			:joins => [
				'LEFT JOIN enrollments ON operational_events.enrollment_id = enrollments.id',
				'LEFT JOIN projects ON enrollments.project_id = projects.id'
			],
			:conditions => [
				"study_subject_id = :subject_id AND " <<
				"operational_event_type_id = :screener_complete AND " <<
				'projects.ended_on IS NULL', 
				{
					:subject_id => self.id,
					:screener_complete => OperationalEventType['screener_complete'].id
				}
			]
		).try(:occurred_on)
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
