#	==	requires
#	*	subject_type_id
class Ccls::StudySubject < Shared
	self.abstract_class = true

#	class NotTwoResponseSets < StandardError; end
	class NotTwoAbstracts < StandardError; end

	belongs_to :subject_type
	belongs_to :vital_status


#
#	TODO - Don't validate anything that the creating user can't do anything about.
#

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
#	pii NEEDS to be before patient.
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

	validates_presence_of :subject_type
	validates_presence_of :subject_type_id

	validates_inclusion_of :do_not_contact, :in => [ true, false ]

	validate :must_be_case_if_patient
	validate :patient_admit_date_is_after_dob
	validate :patient_diagnosis_date_is_after_dob

	with_options :allow_nil => true do |n|
		n.validates_complete_date_for :reference_date
		n.with_options :to => :pii do |o|
			o.delegate :initials
			o.delegate :full_name
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
			o.delegate :local_registrar_no
			o.delegate :childid
			o.delegate :ssn
			o.delegate :patid
			o.delegate :orderno
			o.delegate :studyid
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








	#	Returns number of addresses with 
	#	address_type.code == 'residence'
	def residence_addresses_count
#		addresses.count(
#			:joins => :address_type,
#			:conditions => "address_types.code = 'residence'"
#		)
		addresses.count(:conditions => { :address_type_id => AddressType['residence'].id })
	end

	def to_s
		load 'pii.rb' if RAILS_ENV == 'development'	#	forgets
		#	interesting that I don't have to load 'identifier.rb' ???
		[childid,'(',studyid,full_name,')'].compact.join(' ')
	end

	#	Returns boolean of comparison
	#	true only if type is Case
	def is_case?
#	TODO would really like to drop the SubjectType model
#		and make this use identifier's case_control_type instead
#		identifier.try(:is_case?)
		subject_type.try(:code) == 'Case'
	end

	def race_names
		races.collect(&:to_s).join(', ')
	end

	#	Returns home exposures interview
	def hx_interview
#		identifier.interviews.find(:first,
		interviews.find(:first,
			:conditions => "projects.code = 'HomeExposures'",
			:joins => [:instrument_version => [:instrument => :project]]
#		) unless identifier.nil?
		)
	end

	def is_eligible_for_invitation?
		!self.email.blank?
	end

#	def dust_kit_status
#		dust_kit.try(:status) || 'None'
#	end

	#	NOTE don't forget that deep_merge DOES NOT WORK on HashWithIndifferentAccess

	##
	#	StudySubjects with an enrollment in HomeExposures
	def self.for_hx(params={})
#		StudySubject.search(params.deep_merge(
		StudySubject.search(params.dup.deep_merge(
			:projects=>{hx_id=>{}}
		))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.for_hx_interview(params={})
#		StudySubject.search(params.deep_merge(
		StudySubject.search(params.dup.deep_merge(
			:projects=>{hx_id=>{:chosen=>true}}
		))
#		@study_subjects = StudySubjectSearch.new(params).study_subjects
#	eventually
#		@study_subjects = hx.study_subjects.search(params.merge(
#			:interview_outcome => 'incomplete'
#		))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.need_gift_card(params={})
#		for_hx_followup(params.merge({
		for_hx_followup(params.dup.merge({
			:has_gift_card => false
		}))
	end

	##
	#	StudySubjects with an enrollment in HomeExposures and ...
	def self.for_hx_followup(params={})
#	Why in 3 statements?
#		options = params.dup.deep_merge(
#			:projects=>{hx_id=>{}}
#		)
#		options.merge!(
#			:search_gift_cards => true,
#			:sample_outcome => 'complete',
#			:interview_outcome => 'complete'
#		)
#		StudySubject.search(options)
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
#	Why in 3 statements?
#		options = params.dup.deep_merge(
#			:projects=>{hx_id=>{}}
#		)
#		options.merge!(
##			:sample_outcome => 'incomplete',
#			:interview_outcome => 'complete'
#		)
#		StudySubject.search(options)
		StudySubject.search(params.dup.deep_merge(
			:projects=>{hx_id=>{}},
#			:sample_outcome => 'incomplete',
			:interview_outcome => 'complete'
		))
	end

	def self.search(params={})
		StudySubjectSearch.new(params).study_subjects
	end

#	#	Rails' update_all DOES NOT SUPPORT JOINS despite many requests online.
#	#	I must admit that it was unbelievably complex.  NOT.
#	#	All I did was split the first line, and jam the joins in the middle.
#	#	The sole purpose of all this is for the Patient callback 
#	#	to update all of the matchingid study_subjects' reference date.
#	#	If this begins to cause problems elsewhere, rename it here
#	#	and in the Patient model's call.
#	#	created "ccls_update_all" to avoid problems and ensure
#	#		rcov gets 100% coverage
#	def self.ccls_update_all(updates, conditions = nil, options = {})
#		sql  = "UPDATE #{quoted_table_name} "
#		scope = scope(:find)
#		select_sql = ""
#		add_joins!(select_sql, options[:joins], scope) if options.has_key?(:joins)
#		select_sql.concat "SET #{sanitize_sql_for_assignment(updates)} "
#		add_conditions!(select_sql, conditions, scope)
#		add_order!(select_sql, options[:order], nil)
#		sql.concat(select_sql)
#		connection.update(sql, "#{name} Update")
#	end

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

			StudySubject.update_study_subjects_reference_date( study_subject_ids, admit_date )
		end
		true
	end
	alias_method :update_subjects_reference_date_matching, 
		:update_study_subjects_reference_date_matching

protected

	def self.update_study_subjects_reference_date(study_subject_ids,new_reference_date)
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (1,2)) 
		# UPDATE `study_subjects` SET `reference_date` = '2011-06-02' WHERE (`subjects`.`id` IN (NULL)) 
		unless study_subject_ids.empty?
			StudySubject.update_all(
				{:reference_date => new_reference_date },
				{ :id => study_subject_ids })
		end
	end
	class << self
		alias_method :update_subjects_reference_date, 
			:update_study_subjects_reference_date
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
		#	Notes on accepts_nested_attributes_for :something when creating ...
		#		immediately builds association via build_something with something_attributes
		#		uses autosave to set
		#			validate to validate_associated_records_for_something
		#			after_save to autosave_associated_records_for_something
		#
		#			build_something called as soon as the params are passed to new()
		#				before the save chain even begins.  Because of that, patient
		#				will exist at validation time.
		# * (-) <tt>save</tt>
		# * (-) <tt>valid</tt>
		# * (1) <tt>before_validation</tt>
		# * (2) <tt>before_validation_on_create</tt>
		# * (-) <tt>validate</tt>
		#			validate_associated_records_for_something I think
		# * (-) <tt>validate_on_create</tt>
		# * (3) <tt>after_validation</tt>
		# * (5) <tt>before_save</tt>
		# * (6) <tt>before_create</tt>
		# * (-) <tt>create</tt>					#	id of self not known 'til now
		# * (7) <tt>after_create</tt>
		# * (8) <tt>after_save</tt>
		#			autosave_associated_records_for_something I think
		#
		#	order of declaration will have some impact on what order some things are called
#	In study_subject before_validation
#	In patient before_validation
#	In patient validate
#	In patient after_validation
#	In study_subject validate
#	In study_subject after_validation
		#		
		if !patient.nil? and !is_case?
			errors.add(:patient ,"must be case to have patient info")
		end
	end

end
