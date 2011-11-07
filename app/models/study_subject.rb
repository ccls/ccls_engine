#	==	requires
#	*	subject_type_id
class StudySubject < Shared
#
#	NOTE: Don't validate anything that the creating user can't do anything about.
#

	class NotTwoAbstracts < StandardError; end

	belongs_to :subject_type
	belongs_to :vital_status

	has_many :subject_races
	has_many :subject_languages
	has_and_belongs_to_many :analyses
	has_many :addressings
	has_many :enrollments
	has_many :gift_cards
	has_many :phone_numbers
	has_many :samples
	has_many :interviews
	has_one :home_exposure_response
	has_one :homex_outcome
	has_many :bc_requests

##########
#
#	Declaration order does matter.  Because of a patient callback that 
#	references the study_subject's dob when using nested attributes, 
#	pii NEEDS to be BEFORE patient.
#
#	identifier should also be before patient
#
	has_one :identifier
	has_one :pii
	has_one :patient
#
##########

	with_options :conditions => ["projects.code = 'HomeExposures'"], :include => :project do |p|
		p.has_one :hx_enrollment, :class_name => "Enrollment"
		p.has_one :hx_gift_card,  :class_name => "GiftCard"
	end


	has_many :races,     :through => :subject_races
	has_many :languages, :through => :subject_languages
	has_many :addresses, :through => :addressings

	has_many :abstracts
	has_one :first_abstract, :class_name => 'Abstract',
		:conditions => [
			"entry_1_by_uid IS NOT NULL AND " <<
			"entry_2_by_uid IS NULL AND " <<
			"merged_by_uid  IS NULL" ]
	has_one :second_abstract, :class_name => 'Abstract',
		:conditions => [
			"entry_2_by_uid IS NOT NULL AND " <<
			"merged_by_uid  IS NULL" ]
	has_one :merged_abstract, :class_name => 'Abstract',
		:conditions => [ "merged_by_uid IS NOT NULL" ]
	has_many :unmerged_abstracts, :class_name => 'Abstract',
		:conditions => [ "merged_by_uid IS NULL" ]


	after_create :add_new_subject_operational_event
	#	if want to compare, must be in a BEFORE_save?
#	before_save  :add_subject_died_operational_event
	after_save   :add_subject_died_operational_event


	validates_presence_of :subject_type
	validates_presence_of :subject_type_id

	validate :presence_of_sex
	validates_inclusion_of :sex, :in => %w( M F DK ), :allow_blank => true
	validates_inclusion_of :do_not_contact, :in => [ true, false ]

	validate :must_be_case_if_patient
	validate :patient_admit_date_is_after_dob
	validate :patient_diagnosis_date_is_after_dob

	with_options :allow_nil => true do |n|
		n.validates_complete_date_for :reference_date
		n.with_options :to => :patient do |o|
			o.delegate :admit_date
			o.delegate :organization
			o.delegate :organization_id
			o.delegate :hospital_no
		end
		n.with_options :to => :pii do |o|
			o.delegate :initials
			o.delegate :email
			o.delegate :last_name
			o.delegate :first_name
			o.delegate :dob
			o.delegate :fathers_name
			o.delegate :mothers_name
			o.delegate :mother_maiden_name
		end
		n.with_options :to => :identifier do |o|
			o.delegate :state_id_no
			o.delegate :state_registrar_no
			o.delegate :local_registrar_no
			o.delegate :ssn
			o.delegate :patid
			o.delegate :orderno
#			o.delegate :studyid
		end
		n.with_options :to => :homex_outcome do |o|
			o.delegate :interview_outcome
			o.delegate :interview_outcome_on
			o.delegate :sample_outcome
			o.delegate :sample_outcome_on
		end
	end

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
	accepts_nested_attributes_for :pii
	accepts_nested_attributes_for :homex_outcome
	accepts_nested_attributes_for :identifier
	accepts_nested_attributes_for :patient

	def father
		StudySubject.find(:first,
			:include => [:pii,:identifier,:subject_type],
			:joins => :identifier,
			:conditions => { 
				'identifiers.familyid' => identifier.familyid,
				:subject_type_id       => SubjectType['Father'].id
			}
		)
	end

	def child
		if subject_type == SubjectType['Mother']
			StudySubject.find(:first,
				:include => [:pii,:identifier,:subject_type],
				:joins => :identifier,
				:conditions => [
					"study_subjects.id != ? AND identifiers.subjectid = ?", 
						id, identifier.familyid ]
			)
		else
			nil
		end
	end

	def mother
		StudySubject.find(:first,
			:include => [:pii,:identifier,:subject_type],
			:joins => :identifier,
			:conditions => { 
				'identifiers.familyid' => identifier.familyid,
				:subject_type_id       => SubjectType['Mother'].id
			}
		)
	end

	def family
#	TODO what if familyid is NULL?
		StudySubject.find(:all,
			:include => [:pii,:identifier,:subject_type],
			:joins => :identifier,
			:conditions => [
				"study_subjects.id != ? AND identifiers.familyid = ?", 
					id, identifier.familyid ]
		)
	end

	def matching
#	TODO what if matchingid is NULL?
		StudySubject.find(:all,
			:include => [:pii,:identifier,:subject_type],
			:joins => :identifier,
			:conditions => [
				"study_subjects.id != ? AND identifiers.matchingid = ?", 
					id, identifier.matchingid ]
		)
	end

	def controls
#	TODO what if subject is not a case?
		StudySubject.find(:all, 
			:include => [:pii,:identifier,:subject_type],
			:joins => :identifier,
			:conditions => [
				"study_subjects.id != ? AND identifiers.patid = ? AND subject_type_id = ?", 
					id, patid, SubjectType['Control'].id ] 
		)
	end

	def rejected_controls
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
		require_dependency 'pii.rb' unless Pii
		#	interesting that I don't have to load 'identifier.rb' ???
		[childid,'(',studyid,full_name,')'].compact.join(' ')
	end

	#	The default full_name if non-existant is ALSO in pii.
	def full_name
		pii.try(:full_name) || '[name not available]'
	end

	#	Returns boolean of comparison
	#	true only if type is Case
	def is_case?
		subject_type == SubjectType['Case']
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

	#	NOTE don't forget that deep_merge DOES NOT WORK on HashWithIndifferentAccess

	##
	#	StudySubjects with an enrollment in HomeExposures
	def self.for_hx(params={})
		StudySubject.search(params.dup.deep_merge(
			:projects=>{hx_id=>{}}
		))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.for_hx_interview(params={})
		StudySubject.search(params.dup.deep_merge(
			:projects=>{hx_id=>{:chosen=>true}}
		))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.need_gift_card(params={})
		for_hx_followup(params.dup.merge({
			:has_gift_card => false
		}))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.for_hx_followup(params={})
		StudySubject.search( params.dup.deep_merge(
			:projects=>{hx_id=>{}},
			:search_gift_cards => true,
			:sample_outcome => 'complete',
			:interview_outcome => 'complete'
		))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.for_hx_sample(params={})
		StudySubject.search(params.dup.deep_merge(
			:projects=>{hx_id=>{}},
#			:sample_outcome => 'incomplete',
			:interview_outcome => 'complete'
		))
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

	##
	#	triggered from patient and eventually from pii
	def update_patient_was_under_15_at_dx
		#	due to the high probability that self, pii and patient will not
		#		yet be resolved, we have to get the associations manually.
		my_pii     = Pii.find_by_study_subject_id(self.attributes['id'])
		my_patient = Patient.find_by_study_subject_id(self.attributes['id'])
		if my_pii and my_pii.dob and my_patient and my_patient.admit_date
			#
			#	update_all(updates, conditions = nil, options = {})
			#
			#		Updates all records with details given if they match a set of 
			#		conditions supplied, limits and order can also be supplied. 
			#		This method constructs a single SQL UPDATE statement and sends 
			#		it straight to the database. It does not instantiate the involved 
			#		models and it does not trigger Active Record callbacks. 
			#
			Patient.update_all({
				:was_under_15_at_dx => (((
					my_patient.admit_date.to_date - my_pii.dob.to_date 
					) / 365 ) < 15 )}, { :id => my_patient.id })
				#	crude and probably off by a couple days
				#	would be better to compare year, month then day
		end
		#	make sure we return true
		true
	end

	##
	#	
	def update_study_subjects_reference_date_matching(*matchingids)
		logger.debug "DEBUG: In update_study_subjects_reference_date_matching(*matchingids)"
		logger.debug "DEBUG: update_study_subjects_reference_date_matching(#{matchingids.join(',')})"
#	if matchingids ~ [nil,12345]
#		identifier was either just created or matchingid added (compact as nil not needed)
#	if matchingids ~ [12345,nil]
#		matchingid was removed (compact as nil not needed)
#	if matchingids ~ [12345,54321]
#		matchingid was just changed
#	if matchingids ~ []
#		trigger came from Patient so need to find matchingid

		#	due to the high probability that self and identifier will not
		#		yet be resolved, we have to get the associations manually.
		my_identifier = Identifier.find_by_study_subject_id(self.attributes['id'])
		matchingids.compact.push(my_identifier.try(:matchingid)).uniq.each do |matchingid|
			study_subject_ids = if( !matchingid.nil? )
				Identifier.find_all_by_matchingid(matchingid
					).collect(&:study_subject_id)
			else
				[id]
			end

			#	SHOULD only ever be 1 patient found amongst the study_subject_ids although there is
			#		currently no validation applied to the uniqueness of matchingid
			#	If there is more than one patient for a given matchingid, this'll just be wrong.

			matching_patient = Patient.find_by_study_subject_id(study_subject_ids)
			admit_date = matching_patient.try(:admit_date)

			logger.debug "DEBUG: calling StudySubject.update_study_subjects_reference_date(#{study_subject_ids.join(',')},#{admit_date})"
			StudySubject.update_study_subjects_reference_date( study_subject_ids, admit_date )
		end
		true
	end
#	alias_method :update_subjects_reference_date_matching, 
#		:update_study_subjects_reference_date_matching

	def create_mother
		existing_mother = mother
		if existing_mother
			existing_mother
		else
			new_mother = StudySubject.create!({
				:subject_type => SubjectType['Mother'],
				:vital_status => VitalStatus['living'],
				:sex => 'F',			#	TODO M/F or male/female? have to check.
#				:hispanicity_id => mother_hispanicity_id,	#	TODO where from? 
				:pii_attributes => {
					:first_name  => pii.try(:mother_first_name),
					:middle_name => pii.try(:mother_middle_name),
					:last_name   => pii.try(:mother_last_name),
					:maiden_name => pii.try(:mother_maiden_name),
					#	flag to not require the dob as won't have one
					:subject_is_mother => true  
				},
				:identifier => Identifier.new { |i|
					#	protected attributes!
					i.matchingid = identifier.matchingid
					i.familyid   = identifier.familyid
				}
			})
			new_mother.assign_icf_master_id
			new_mother
		end
	end

	def create_father
		existing_father = father
		if existing_father
			existing_father
		else
			new_father = StudySubject.create!({
				:subject_type => SubjectType['Father'],
				:vital_status => VitalStatus['living'],
				:sex => 'M',			#	TODO M/F or male/female? have to check.
#				:hispanicity_id => mother_hispanicity_id,	#	TODO where from? 
				:pii_attributes => {
					:first_name  => pii.try(:father_first_name),
					:middle_name => pii.try(:father_middle_name),
					:last_name   => pii.try(:father_last_name),
					#	flag to not require the dob as won't have one
					:subject_is_father => true  
				},
				:identifier => Identifier.new { |i|
					#	protected attributes!
					i.matchingid = identifier.matchingid
					i.familyid   = identifier.familyid
				}
			})
			new_father.assign_icf_master_id
			new_father
		end
	end

	def assign_icf_master_id
		if self.identifier.icf_master_id.blank?
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
#		assume that self is a case?
		#	code from CandidateControl
		#require_dependency 'identifier.rb' unless Identifier
		last_control = StudySubject.find(:first, 
			:joins => :identifier, 
			:order => 'identifiers.orderno DESC', 
			:conditions => { 
				:subject_type_id => SubjectType['Control'].id,
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
	#		hospital_no
	#		dob
	#		sex
	#		admit_date
	#		organization_id
	#
	def self.duplicates(params={})
		conditions = [[],{}]
		#	being blank is OK for mysql, but should be removed for simplicity and clarity
		if params.has_key?(:hospital_no) and !params[:hospital_no].blank?
			conditions[0] << '(hospital_no = :hospital_no)'
			conditions[1][:hospital_no] = params[:hospital_no]
		end
		if params.has_key?(:dob) and !params[:dob].blank? and
				params.has_key?(:sex) and !params[:sex].blank?
			conditions[0] << '(dob = :dob AND sex = :sex)'
			conditions[1][:dob] = params[:dob]
			conditions[1][:sex] = params[:sex]
		end
		if params.has_key?(:admit_date) and !params[:admit_date].blank? and
				params.has_key?(:organization_id) and !params[:organization_id].blank?
			conditions[0] << '(admit_date = :admit AND organization_id = :org)'
			conditions[1][:admit] = params[:admit_date]
			conditions[1][:org] = params[:organization_id]
		end
		#	NOTE dates may be a problem? maybe not? seem to work
#puts
#puts [ conditions[0].join(' OR '),*(conditions[1].flatten) ].inspect
#	["(identifiers.hospital_no = ?) OR (piis.dob = ? AND sex = ?) OR (patients.admit_date = ? AND patients.organization_id = ?)", "matchthis", Fri, 14 May 1976, "M", Mon, 24 Oct 2011, 1]
		unless conditions[0].blank?
			find(:all,
				#	have to do a LEFT JOIN, not the default INNER JOIN, here
				#			:joins => [:pii,:patient,:identifier]
				#	otherwise would only include subjects with pii, patient and identifier,
				#	which would effectively exclude controls. (maybe that's ok?)
				:joins => [
					'LEFT JOIN piis ON study_subjects.id = piis.study_subject_id',
					'LEFT JOIN patients ON study_subjects.id = patients.study_subject_id',
					'LEFT JOIN identifiers ON study_subjects.id = identifiers.study_subject_id'
				],
				:conditions => [ conditions[0].join(' OR '), conditions[1] ]
			) 
#					*(conditions[1].flatten) ]
		else
			[]
		end
	end

	def duplicates
		StudySubject.duplicates(
			:hospital_no => self.hospital_no,
			:dob => self.dob,
			:sex => self.sex,
			:admit_date => self.admit_date,
			:organization_id => self.organization_id
		)
	end

	def self.find_case_by_patid(patid)
		StudySubject.find(:first,	#	patid is unique so better only be 1
			:joins => [ 
				'LEFT JOIN identifiers ON study_subjects.id = identifiers.study_subject_id' 
			],
			:conditions => [
				'study_subjects.subject_type_id = ? AND identifiers.patid = ?',
				SubjectType['Case'].id, patid
			]
		)
	end

	def icf_master_id
		( identifier.try(:icf_master_id).blank? ) ? 
			"[no ID assigned]" : identifier.icf_master_id
	end
#	alias_method :icf_master_id_or_notice, :icf_master_id

	def childid
		if subject_type == SubjectType['Mother']
			"#{child.try(:childid)} (mother)"
		else
			identifier.try(:childid)
		end
	end

	def studyid
		if subject_type == SubjectType['Mother']
			"n/a"
		else
			identifier.try(:studyid)
		end
	end

protected

	def self.update_study_subjects_reference_date(study_subject_ids,new_reference_date)
		logger.debug "DEBUG: In StudySubject.update_study_subjects_reference_date"
		logger.debug "DEBUG: update_study_subjects_reference_date(#{study_subject_ids.join(',')},#{new_reference_date})"
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (1,2)) 
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (NULL)) 
		unless study_subject_ids.empty?
			StudySubject.update_all(
				{:reference_date => new_reference_date },
				{ :id => study_subject_ids })
		end
	end

	#	This is a duplication of a patient validation that won't
	#	work if using nested attributes.  Don't like doing this.
	def patient_admit_date_is_after_dob
		if !patient.nil? && !patient.admit_date.blank? && 
			!pii.nil? && !pii.dob.blank? && patient.admit_date < pii.dob
			errors.add('patient:admit_date', "is before study_subject's dob.") 
		end
	end

	#	This is a duplication of a patient validation that won't
	#	work if using nested attributes.  Don't like doing this.
	def patient_diagnosis_date_is_after_dob
		if !patient.nil? && !patient.diagnosis_date.blank? && 
			!pii.nil? && !pii.dob.blank? && patient.diagnosis_date < pii.dob
			errors.add('patient:diagnosis_date', "is before study_subject's dob.") 
		end
	end

	def self.hx_id
		#	added try and || for usage on empty db
		Project['HomeExposures'].try(:id)||0
	end

	def must_be_case_if_patient
		if !patient.nil? and !is_case?
			errors.add(:patient ,"must be case to have patient info")
		end
	end

#
#	NOTE be advised that these will no doubt break some tests
#		that are not expecting any operational events.
#

	#	All subjects are to have a CCLS project enrollment, so create after create.
	#	All subjects are to have this operational event, so create after create.
	#	I suspect that this'll be attached to the CCLS project enrollment.
	def add_new_subject_operational_event
		ccls_enrollment = enrollments.find_or_create_by_project_id(Project['ccls'].id)
		ccls_enrollment.operational_events << OperationalEvent.create!(
			:operational_event_type => OperationalEventType['newSubject'],
			:occurred_on            => Date.today
		)
	end

	#	Add this if the vital status changes to deceased.
	#	I suspect that this'll be attached to the CCLS project enrollment.
	def add_subject_died_operational_event
		if( ( vital_status_id == VitalStatus['deceased'].id ) && 
				( vital_status_id_was != VitalStatus['deceased'].id ) )
			ccls_enrollment = enrollments.find_or_create_by_project_id(Project['ccls'].id)
			ccls_enrollment.operational_events << OperationalEvent.create!(
				:operational_event_type => OperationalEventType['subjectDied'],
				:occurred_on            => Date.today
			)
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

end
