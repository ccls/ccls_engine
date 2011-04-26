#	==	requires
#	*	subject_type_id
class Ccls::Subject < Shared
	self.abstract_class = true

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
		f.has_one :identifier
		f.has_one :home_exposure_response
		f.has_one :homex_outcome
		f.has_one :patient
		f.has_one :pii
		f.with_options :conditions => ["projects.code = 'HomeExposures'"], :include => :project do |p|
			p.has_one :hx_enrollment, :class_name => "Enrollment"
			p.has_one :hx_gift_card,  :class_name => "GiftCard"
		end
	end
	has_many :races, :through => :subject_races
	has_many :languages, :through => :subject_languages
	has_many :addresses, :through => :addressings

	accepts_nested_attributes_for :gift_cards
	accepts_nested_attributes_for :subject_races, 
		:allow_destroy => true,
		:reject_if => proc{|attributes| attributes['race_id'].blank? }

	validates_presence_of :subject_type
	validates_presence_of :subject_type_id

	validates_inclusion_of :do_not_contact, :in => [ true, false ]

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
	accepts_nested_attributes_for :pii
	accepts_nested_attributes_for :homex_outcome
	accepts_nested_attributes_for :identifier

#	Where do I use patient_attributes?
#		ODMS does for new subject
	accepts_nested_attributes_for :patient
	validate :must_be_case_if_patient_attributes
	def must_be_case_if_patient_attributes
		if !patient.nil? and !is_case?
			errors.add(:patient ,"must be case to have patient info")
		end
	end

#	class NotTwoResponseSets < StandardError; end

	#	Returns number of addresses with 
	#	address_type.code == 'residence'
	def residence_addresses_count
		addresses.count(
			:joins => :address_type,
			:conditions => "address_types.code = 'residence'"
		)
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
		identifier.interviews.find(:first,
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
	def self.update_all(updates, conditions = nil, options = {})
####
#	BEGIN Jake's Hack
#		sql  = "UPDATE #{quoted_table_name} SET #{sanitize_sql_for_assignment(updates)} "

		sql  = "UPDATE #{quoted_table_name} "

		scope = scope(:find)
		select_sql = ""

		add_joins!(select_sql, options[:joins], scope) if options.has_key?(:joins)
		select_sql.concat "SET #{sanitize_sql_for_assignment(updates)} "

#	END Jake's Hack
####

		add_conditions!(select_sql, conditions, scope)

		if options.has_key?(:limit) || (scope && scope[:limit])
			# Only take order from scope if limit is also provided by scope, this
			# is useful for updating a has_many association with a limit.
			add_order!(select_sql, options[:order], scope)

			add_limit!(select_sql, options, scope)
			sql.concat(connection.limited_update_conditions(select_sql, 
				quoted_table_name, connection.quote_column_name(primary_key)))
		else
			add_order!(select_sql, options[:order], nil)
			sql.concat(select_sql)
		end

		connection.update(sql, "#{name} Update")
	end

protected

	def self.hx_id
		#	added try and || for usage on empty db
		Project['HomeExposures'].try(:id)||0
	end

end
