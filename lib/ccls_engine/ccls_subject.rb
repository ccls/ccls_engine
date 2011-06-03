#	==	requires
#	*	subject_type_id
class Ccls::Subject < Shared
	self.abstract_class = true

#
#	TODO clean this up.  Seriously
#

#	belongs_to :hispanicity
	belongs_to :subject_type
	belongs_to :vital_status

	with_options :foreign_key => 'study_subject_id' do |f|
		f.has_many :subject_races
		f.has_many :subject_languages
		f.has_and_belongs_to_many :analyses
		f.has_many :addressings
		f.has_many :enrollments
		f.has_many :gift_cards
		f.has_many :phone_numbers
		f.has_many :samples
		f.has_many :interviews
		f.has_one :identifier
		f.has_one :home_exposure_response
		f.has_one :homex_outcome

##########
#
#	Declaration order does matter.  Because of a patient callback that 
#	references the subject's dob when using nested attributes, 
#	pii NEEDS to be before patient.
#
		f.has_one :pii
		f.has_one :patient
#
##########

		f.with_options :conditions => ["projects.code = 'HomeExposures'"], :include => :project do |p|
			p.has_one :hx_enrollment, :class_name => "Enrollment"
			p.has_one :hx_gift_card,  :class_name => "GiftCard"
		end
	end
	has_many :races,     :through => :subject_races
	has_many :languages, :through => :subject_languages
	has_many :addresses, :through => :addressings

	validates_presence_of :subject_type
	validates_presence_of :subject_type_id

	validates_inclusion_of :do_not_contact, :in => [ true, false ]

	validate :must_be_case_if_patient

	with_options :allow_nil => true do |n|
		n.validates_complete_date_for :reference_date
		n.with_options :to => :pii do |o|
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

	#	can lead to multiple piis in db for subject
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







#	class NotTwoResponseSets < StandardError; end

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
		[childid,'(',studyid,full_name,')'].compact.join(' ')
	end

	#	Returns boolean of comparison
	#	true only if type is Case
	def is_case?
		subject_type.try(:code) == 'Case'
	end

	def race_names
		races.collect(&:to_s).join(', ')
	end
#	replaced with has_one relationship
#	#	Returns home exposures enrollment
#	def hx_enrollment
#		enrollments.find(:first,
#			:conditions => "projects.code = 'HomeExposures'",
#			:joins => :project)
#	end

	#	Returns home exposures interview
	def hx_interview
#		identifier.interviews.find(:first,
		interviews.find(:first,
			:conditions => "projects.code = 'HomeExposures'",
			:joins => [:instrument_version => [:instrument => :project]]
		) unless identifier.nil?
	end

	def is_eligible_for_invitation?
		!self.email.blank?
	end

#	def dust_kit_status
#		dust_kit.try(:status) || 'None'
#	end

	def self.for_hx(params={})
#puts "In for_hx"
#puts params.inspect
#puts params.deep_merge(:projects=>{hx_id=>{}}).inspect
#puts "searching ..."
		Subject.search(params.deep_merge(
			:projects=>{hx_id=>{}}
		))
	end

	def self.for_hx_interview(params={})
		Subject.search(params.deep_merge(
			:projects=>{hx_id=>{:chosen=>true}}
		))
#		@subjects = SubjectSearch.new(params).subjects
#	eventually
#		@subjects = hx.subjects.search(params.merge(
#			:interview_outcome => 'incomplete'
#		))
	end

	def self.need_gift_card(params={})
		for_hx_followup(params.merge({
			:has_gift_card => false
		}))
	end

	def self.for_hx_followup(params={})
		options = params.deep_merge(
			:projects=>{hx_id=>{}}
		)
		options.merge!(
			:search_gift_cards => true,
			:sample_outcome => 'complete',
			:interview_outcome => 'complete'
		)
		Subject.search(options)
	end

	def self.for_hx_sample(params={})
		options = params.deep_merge(
			:projects=>{hx_id=>{}}
		)
		options.merge!(
#			:sample_outcome => 'incomplete',
			:interview_outcome => 'complete'
		)
		Subject.search(options)
	end

	def self.search(params={})
		SubjectSearch.new(params).subjects
	end

	#	Rails' update_all DOES NOT SUPPORT JOINS despite many requests online.
	#	I must admit that it was unbelievably complex.  NOT.
	#	All I did was split the first line, and jam the joins in the middle.
	#	The sole purpose of all this is for the Patient callback 
	#	to update all of the matchingid subjects' reference date.
	#	If this begins to cause problems elsewhere, rename it here
	#	and in the Patient model's call.
	#	created "ccls_update_all" to avoid problems and ensure
	#		rcov gets 100% coverage
	def self.ccls_update_all(updates, conditions = nil, options = {})
		sql  = "UPDATE #{quoted_table_name} "
		scope = scope(:find)
		select_sql = ""
		add_joins!(select_sql, options[:joins], scope) if options.has_key?(:joins)
		select_sql.concat "SET #{sanitize_sql_for_assignment(updates)} "
		add_conditions!(select_sql, conditions, scope)
		add_order!(select_sql, options[:order], nil)
		sql.concat(select_sql)
		connection.update(sql, "#{name} Update")
	end


	class NotTwoAbstracts < StandardError; end

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

	def abstracts_the_same?
		raise Subject::NotTwoAbstracts unless abstracts_count == 2
		#	abstracts.inject(:is_the_same_as?) was nice
		#	but using inject is ruby >= 1.8.7
		return abstracts[0].is_the_same_as?(abstracts[1])
	end

	def abstract_diffs
		raise Subject::NotTwoAbstracts unless abstracts_count == 2
		#	abstracts.inject(:diff) was nice
		#	but using inject is ruby >= 1.8.7
		return abstracts[0].diff(abstracts[1])
	end

	#	triggered from patient and eventually from pii
	def update_patient_was_under_15_at_dx
		reload	#	reload subject so associations resolved
		if dob and patient and patient.admit_date
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
					patient.admit_date.to_date - dob.to_date 
					) / 365 ) < 15 )}, { :id => patient.id })
				#	crude and probably off by a couple days
				#	would be better to compare year, month then day
		end
		#	make sure we return true
		true
	end

protected

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
		#		
		if !patient.nil? and !is_case?
			errors.add(:patient ,"must be case to have patient info")
		end
	end

end
