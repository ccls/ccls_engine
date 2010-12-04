module FactoryTestHelper

	def full_response(options={})
		survey = Factory(:survey)
		survey_section = Factory(:survey_section, :survey => survey)
		question = Factory(:question, { 
			:survey_section => survey_section }.merge(options[:question]||{}))
		answer = Factory(:answer, { :question => question,
			:response_class => "answer" }.merge(options[:answer]||{}))
		response_set = Factory(:response_set, {
			:survey => survey}.merge(options[:response_set]||{}))
		response = Factory(:response, {
			:response_set => response_set,
			:question => question, 
			:answer => answer}.merge(options[:response]||{})
		)
	end

	def q_and_a_for(survey_section, options={})
		question = Factory(:question, { 
			:survey_section => survey_section 
		}.merge(options[:question]||{}))
		Factory(:answer, { 
			:question => question,
			:response_class => "answer" 
		}.merge(options[:answer]||{}))
		question
	end

	def full_response_set(options={})
		survey = if options[:survey].is_a?(Survey)
			#	A survey and its q and a already exist.
			options[:survey]
		else
			#	assuming that its a hash
			s = Factory(:survey, options[:survey]||{} )
			survey_section = Factory(:survey_section, :survey => s )
			q_and_a_for(survey_section,{
				:question => {
					:data_export_identifier => 'construction_in_home'},
				:answer   => {:data_export_identifier => 2 }
			})
			q_and_a_for(survey_section,{
				:question => {
					:data_export_identifier => 'other_home_remodelling'},
				:answer   => {:data_export_identifier => 1 }
			})
			q_and_a_for(survey_section, { 
				:question => {
					:data_export_identifier => 'type_other_home_remodelling'},
				:answer => { :response_class => "string" }
			})
			q_and_a_for(survey_section, { 
				:question => {:data_export_identifier => 'year_home_built'},
				:answer => { :response_class => "integer" }
			})
			s
		end
		response_set = Factory(:response_set, {
			:survey => survey}.merge(options[:response_set]||{}))

		survey.sections.each do |section|
			section.questions.each do |question|
				response = Factory.build(:response, {
					:response_set => response_set,
					:question => question, 
					:answer => question.answers.first
				}.merge(options[:response]||{}))
				case response.answer.response_class
					when 'string'
						response.string_value = "some other remodelling"
					when 'integer'
						response.integer_value = 1942
				end
				response.save
			end
		end
		response_set
	end

	def fill_out_survey(options={})
		response_set = Factory(:response_set,{
			:completed_at => Time.now
		}.merge(options))
		response_set.survey.sections.each do |section|
			section.questions.each do |question|
				next if question.answers.length <= 0
				response = Factory.build(:response, {
					:response_set => response_set,
					:question     => question,
					:answer => question.answers.first
				})
				case response.answer.response_class
					when 'string'||'text'
						response.string_value = "some text"
					when 'integer'
						response.integer_value = 1942
				end
				response.save
			end
		end
		response_set
	end

	def create_home_exposure_with_subject(options={})
		subject    = Factory(:subject,options[:subject]||{})
		identifier = Factory(:identifier, :subject => subject)
		project = Project.find_or_create_by_code('HomeExposures')
		Factory(:enrollment, (options[:enrollment]||{}).merge(
			:subject => subject, :project => project ))
		subject
	end
	alias_method :create_hx_subject, :create_home_exposure_with_subject

	def create_eligible_hx_subject()
		subject = nil
		assert_nil subject
		assert_difference('Enrollment.count',1) {
		assert_difference('Subject.count',1) {
			subject = create_hx_subject(:enrollment => {
				:is_eligible => YNDK[:yes] })
		} }
		assert_not_nil subject
		assert_subject_is_eligible(subject)
		subject
	end

	def create_hx_interview_subject(options={})
		subject = create_hx_subject
#		identifier = Factory(:identifier, :subject => subject)
		instrument = Factory(:instrument, 
			:project => Project.find_or_create_by_code('HomeExposures'))
		instrument_version = Factory(:instrument_version, 
			:instrument => instrument)
		interview = Factory(:interview, 
			:identifier => subject.identifier,
			:instrument_version => instrument_version)
		subject
	end

	def create_subject(options = {})
		record = Factory.build(:subject,options)
		record.save
		record
	end

	def create_subjects(count=0,options={})
		subjects = []
		count.times{ subjects.push(create_subject(options)) }
		return subjects
	end

	def create_subjects_with_recruitment_priorities(*priorities)
		project = Factory(:project)
		subjects = priorities.collect do |priority|
			subject = create_subject
			Factory(:enrollment, :project => project, 
				:subject => subject,
				:recruitment_priority => priority)
			subject
		end
		return [project,*subjects]
	end

	def create_subject_with_gift_card_number(gift_card_number)
		subject = create_subject
		Factory(:gift_card, 
			:subject => subject,
			:number  => gift_card_number )
		subject
	end

	def create_subject_with_childid(childid)
		subject = create_subject
		Factory(:identifier, 
			:subject => subject,
			:childid => childid )
		subject
	end

	def three_subjects_with_childid
		create_subjects_with_childids(9,3,6)
	end

	def create_subject_with_patid(patid)
		subject = create_subject
		Factory(:identifier, 
			:subject => subject,
			:patid   => patid )
		subject
	end
	alias_method :create_subject_with_studyid,   :create_subject_with_patid

	def three_subjects_with_patid
		create_subjects_with_patids(9,3,6)
	end
	alias_method :three_subjects_with_studyid, :three_subjects_with_patid

	def create_subject_with_last_name(last_name)
		create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => last_name ))
	end
	
	def three_subjects_with_last_name
		create_subjects_with_last_names('9','3','6')
	end

	def create_subject_with_first_name(first_name)
		create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => first_name ))
	end
	
	def three_subjects_with_first_name
		create_subjects_with_first_names('9','3','6')
	end

	def create_subject_with_dob(dob)
		create_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse(dob) ))
	end

	def three_subjects_with_dob
		create_subjects_with_dobs('12/31/2005','12/31/2001','12/31/2003')
	end

	def create_subject_with_sample_outcome(outcome)
		s = create_hx_subject
		s.update_attributes( 
			:homex_outcome_attributes => Factory.attributes_for(:homex_outcome,
				:sample_outcome_id => outcome) )
		s
	end

	def three_subjects_with_sample_outcome
		create_subjects_with_sample_outcomes('9','3','6')
	end

	def create_subject_with_interview_outcome_on(date)
		create_hx_subject(:subject => {
			:homex_outcome_attributes => Factory.attributes_for(:homex_outcome,
				:interview_outcome_on => date ) })
	end

	def three_subjects_with_interview_outcome_on
		create_subjects_with_interview_outcome_ons('12/31/2005','12/31/2001','12/31/2003')
	end

	def create_subject_with_sample_sent_on(date)
		create_hx_subject		#	will need extended eventually
	end

	def three_subjects_with_sample_sent_on
		create_subjects_with_sample_sent_ons('12/31/2005','12/31/2001','12/31/2003')
	end

	def create_subject_with_sample_received_on(date)
		create_hx_subject		#	will need extended eventually
	end

	def three_subjects_with_sample_received_on
		create_subjects_with_sample_received_ons('12/31/2005','12/31/2001','12/31/2003')
	end

	def method_missing_with_pluralization(symb,*args, &block)
		method_name = symb.to_s
		if method_name =~ /^create_subjects_with_(.*)$/
			attribute = $1.singularize
			args.collect do |arg|
				send("create_subject_with_#{attribute}",arg)
			end
		else
			method_missing_without_pluralization(symb, *args, &block)
		end
	end

	def self.included(base)
		base.alias_method_chain :method_missing, :pluralization
	end

end
ActiveSupport::TestCase.send(:include, FactoryTestHelper)
