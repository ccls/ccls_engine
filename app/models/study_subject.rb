#	==	requires
#	*	subject_type_id
class StudySubject < ActiveRecordShared

	class NotTwoAbstracts < StandardError; end
	class DuplicatesFound < StandardError; end

	include StudySubjectAssociations
	include StudySubjectCallbacks
	include StudySubjectValidations
	include StudySubjectDelegations
	include Pii


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
#	accepts_nested_attributes_for :pii
	accepts_nested_attributes_for :homex_outcome
	accepts_nested_attributes_for :identifier
	accepts_nested_attributes_for :patient


	#	Find the case or control subject with matching familyid except self.
	def child
#	TODO what if identifier is NULL?
#	TODO what if familyid is NULL?
		if subject_type_id == StudySubject.subject_type_mother_id
#	&& !identifier.nil? && !identifier.familyid.blank?
			StudySubject.find(:first,
#				:include => [:pii,:identifier,:subject_type],
				:include => [:identifier,:subject_type],
				:joins => :identifier,
				:conditions => [
#					"study_subjects.id != ? AND identifiers.subjectid = ?", 
					"study_subjects.id != ? AND identifiers.subjectid = ? AND subject_type_id IN (?)", 
						id, identifier.familyid, [
							StudySubject.subject_type_case_id,StudySubject.subject_type_control_id] ]
			)
		else
			nil
		end
	end

	#	Find the subject with matching familyid and subject_type of Mother.
	def mother
#	TODO what if identifier is NULL?
#	TODO what if familyid is NULL?
#	if !identifier.nil? && !identifier.familyid.blank?
		StudySubject.find(:first,
#			:include => [:pii,:identifier,:subject_type],
			:include => [:identifier,:subject_type],
			:joins => :identifier,
			:conditions => { 
				'identifiers.familyid' => identifier.familyid,
				:subject_type_id       => StudySubject.subject_type_mother_id
			}
		)
	end

	#	Find all the subjects with matching familyid except self.
	def family
		if !identifier.nil? && !identifier.familyid.blank?
			StudySubject.find(:all,
#				:include => [:pii,:identifier,:subject_type],
				:include => [:identifier,:subject_type],
				:joins => :identifier,
				:conditions => [
					"study_subjects.id != ? AND identifiers.familyid = ?", 
						id, identifier.familyid ]
			)
		else
			[]
		end
	end

	#	Find all the subjects with matching matchingid except self.
	def matching
		if !identifier.nil? && !identifier.matchingid.blank?
			StudySubject.find(:all,
#				:include => [:pii,:identifier,:subject_type],
				:include => [:identifier,:subject_type],
				:joins => :identifier,
				:conditions => [
					"study_subjects.id != ? AND identifiers.matchingid = ?", 
						id, identifier.matchingid ]
			)
		else
			[]
		end
	end

	#	Find all the subjects with matching patid with subject_type Control except self.
	#	If patid is nil, this sql doesn't work.  
	#			TODO Could fix, but this situation is unlikely.
	def controls
		return [] unless is_case?
		StudySubject.find(:all, 
#			:include => [:pii,:identifier,:subject_type],
			:include => [:identifier,:subject_type],
			:joins => :identifier,
			:conditions => [
				"study_subjects.id != ? AND identifiers.patid = ? AND subject_type_id = ?", 
					id, patid, StudySubject.subject_type_control_id ] 
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
#		require_dependency 'pii.rb' unless Pii
		#	interesting that I don't have to load 'identifier.rb' ???
		[childid,'(',studyid,full_name,')'].compact.join(' ')
	end

#	#	The default full_name if non-existant is ALSO in pii.
#	#	Can't delegate this or won't get '[name not available]' if no pii
#	def full_name
##		pii.try(:full_name) || '[name not available]'
#		full_name || '[name not available]'
#	end

	#	Returns boolean of comparison
	#	true only if type is Case
	def is_case?
		subject_type_id == StudySubject.subject_type_case_id
	end

	#	Returns boolean of comparison
	#	true only if type is Control
	def is_control?
		subject_type_id == StudySubject.subject_type_control_id
	end

	#	Returns boolean of comparison
	#	true only if type is Mother
	def is_mother?
		subject_type_id == StudySubject.subject_type_mother_id
	end

	#	Returns boolean of comparison
	#	true only if type is Father
#	Father seems to be irrelevant so commenting out code.
#	def is_father?
#		subject_type_id == StudySubject.subject_type_father_id
#	end

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
			new_mother = StudySubject.create!({
				:subject_type_id => StudySubject.subject_type_mother_id,
				:vital_status => VitalStatus['living'],
				:sex => 'F',			#	TODO M/F or male/female? have to check.
#				:hispanicity_id => mother_hispanicity_id,	#	TODO where from? 
#				:pii_attributes => {
					:first_name  => mother_first_name,
					:middle_name => mother_middle_name,
					:last_name   => mother_last_name,
					:maiden_name => mother_maiden_name,
					#	flag to not require the dob as won't have one
					:subject_is_mother => true,
#				},
				:identifier => Identifier.new { |i|
					#	protected attributes!
					i.matchingid = identifier.matchingid
					i.familyid   = identifier.familyid
				}
			})
# possibly put in a identifier#after_create ???
#	or study_subject#after_create ???
			new_mother.assign_icf_master_id
			new_mother
		end
	end

# possibly put in a identifier#after_create ???
#	or study_subject#after_create ???
#	seems to cause all kinds of problems when calling as after_create?
	def assign_icf_master_id
		if self.identifier and self.identifier.icf_master_id.blank?
			next_icf_master_id = IcfMasterId.next_unused
			if next_icf_master_id
				self.identifier.update_attribute(:icf_master_id, next_icf_master_id.to_s)
				next_icf_master_id.study_subject = self
				next_icf_master_id.assigned_on   = Date.today
				next_icf_master_id.save!
			end
		end
		self
	end

	def next_control_orderno(grouping='6')
		return nil unless is_case?
		last_control = StudySubject.find(:first, 
			:joins => :identifier, 
			:order => 'identifiers.orderno DESC', 
			:conditions => { 
				:subject_type_id => StudySubject.subject_type_control_id,
				'identifiers.case_control_type' => grouping,
				'identifiers.matchingid' => self.identifier.subjectid
			}
		)
		#	identifier.orderno is delegated to subject for simplicity
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
#					'LEFT JOIN piis ON study_subjects.id = piis.study_subject_id',
					'LEFT JOIN patients ON study_subjects.id = patients.study_subject_id',
					'LEFT JOIN identifiers ON study_subjects.id = identifiers.study_subject_id'
				],
				:conditions => conditions_array
			) 
		else
			[]
		end
	end

	def duplicates(options={})
		StudySubject.duplicates({
			:mother_maiden_name => self.mother_maiden_name,
			:hospital_no => self.hospital_no,
			:dob => self.dob,
			:sex => self.sex,
			:admit_date => self.admit_date,
			:organization_id => self.organization_id
		}.merge(options))
	end

	def self.find_case_by_patid(patid)
		StudySubject.find(:first,	#	patid is unique so better only be 1
			:joins => [ 
				'LEFT JOIN identifiers ON study_subjects.id = identifiers.study_subject_id' 
			],
			:conditions => [
				'study_subjects.subject_type_id = ? AND identifiers.patid = ?',
				StudySubject.subject_type_case_id, patid
			]
		)
	end

	def icf_master_id
		( identifier.try(:icf_master_id).blank? ) ? 
			"[no ID assigned]" : identifier.icf_master_id
	end

	def childid
		if subject_type_id == StudySubject.subject_type_mother_id
			"#{child.try(:childid)} (mother)"
		else
			identifier.try(:childid)
		end
	end

	def studyid
		if subject_type_id == StudySubject.subject_type_mother_id
			"n/a"
		else
			identifier.try(:studyid)
		end
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

	#	Use this to stop the constant checking.
	def self.subject_type_father_id
		@@subject_type_father_id ||= SubjectType['Father'].id
	end
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
