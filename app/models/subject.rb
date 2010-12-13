#	==	requires
#	*	subject_type_id
#	*	race_id
class Subject < Shared

#	belongs_to :hispanicity
	belongs_to :race
	belongs_to :subject_type
	belongs_to :vital_status

	with_options :foreign_key => 'study_subject_id' do |f|
		f.has_and_belongs_to_many :analyses
		f.has_many :addressings
		f.has_many :enrollments
		f.has_many :gift_cards
		f.has_many :phone_numbers
		f.has_many :response_sets
		f.has_many :samples
		f.has_many :survey_invitations
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

	has_many :addresses, :through => :addressings
	accepts_nested_attributes_for :gift_cards

	validates_presence_of :subject_type
	validates_presence_of :race
	validates_presence_of :subject_type_id
	validates_presence_of :race_id

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
			o.delegate :state_id_no
		end
		n.with_options :to => :identifier do |o|
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

#	Where do I use patient_attributes?
#	accepts_nested_attributes_for :patient
#	Where do I use identifier_attributes?
#	accepts_nested_attributes_for :identifier
##	accepts_nested_attributes_for :dust_kit

	class NotTwoResponseSets < StandardError; end

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

	def response_sets_the_same?
		if response_sets.length == 2
			#	response_sets.inject(:is_the_same_as?) was nice
			#	but using inject is ruby >= 1.8.7
			return response_sets[0].is_the_same_as?(response_sets[1])
		else
			raise NotTwoResponseSets
		end
	end

	def response_set_diffs
		if response_sets.length == 2
			#	response_sets.inject(:diff) was nice
			#	but using inject is ruby >= 1.8.7
			return response_sets[0].diff(response_sets[1])
		else
			raise NotTwoResponseSets
		end
	end

	def recreate_survey_invitation(survey)
		SurveyInvitation.destroy_all( 
			:study_subject_id => self.id,
			:survey_id  => survey.id 
		)
		self.survey_invitations.create(
			:survey_id => survey.id
		)
	end

	def is_eligible_for_invitation?
		!self.email.blank?
	end

	def her_invitation
		if survey = Survey.find_by_access_code('home_exposure_survey')
			self.survey_invitations.find_by_survey_id(survey.id)
		end
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

protected

	def self.hx_id
		#	added try and || for usage on empty db
		Project['HomeExposures'].try(:id)||0
	end

end
