module Ccls::FactoryTestHelper

	def create_home_exposure_with_subject(options={})
		subject = identifier = project = nil
		unless options[:patient].nil?
			options[:subject] ||= {}
			options[:subject][:subject_type] = SubjectType['Case']
		end
		assert_difference('Subject.count',1) {
			subject    = Factory(:subject,options[:subject]||{})
		}
		assert_difference('Subject.count',0) {
		assert_difference('Identifier.count',1) {
			identifier = Factory(:identifier, 
				(options[:identifier]||{}).merge(
					:subject => subject))
		} }
		project = Project.find_or_create_by_code('HomeExposures')
		assert_not_nil project
		assert_difference('Subject.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('Enrollment.count',1) {
			Factory(:enrollment, (options[:enrollment]||{}).merge(
				:subject => subject, :project => project ))
		} } }
		unless options[:patient].nil?
			assert_difference('Subject.count',0) {
			assert_difference('Patient.count',1) {
				Factory(:patient, :subject => subject )
			} }
		end
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
#			:identifier => subject.identifier,
			:subject => subject,
			:instrument_version => instrument_version)
		subject
	end

	def create_subject(options = {})
		#	May contain options for testing failing so can't assert
		#	that Subject.count will change here.
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
		project = nil
		assert_difference('Project.count',1) {
			project = Factory(:project)
		}
		subjects = priorities.collect do |priority|
			subject = nil
			assert_difference('Subject.count',1) {
				subject = create_subject
			}
			assert_difference('Enrollment.count',1){
				Factory(:enrollment, :project => project, 
					:subject => subject,
					:recruitment_priority => priority)
			}
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

	def create_subjects_with_races(count=0,options={})
		subjects = create_subjects(count)
		subjects.each{|s|s.races << Factory(:race)}
		subjects
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
			:patid   => patid.to_s )
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
		create_subjects_with_dobs(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_subject_with_sample_outcome_on(date)
		s = create_hx_subject
		s.update_attributes( 
			:homex_outcome_attributes => Factory.attributes_for(:homex_outcome,
				:sample_outcome_on => date) )
		s
	end

	def three_subjects_with_sample_outcome_on
		create_subjects_with_sample_outcome_ons(
			'12/31/2005','12/31/2001','12/31/2003')
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
		create_subjects_with_interview_outcome_ons(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_subject_with_sent_to_subject_on(date)
		subject = create_hx_subject
		Factory(:sample,
			:subject => subject,
			:sent_to_subject_on => Chronic.parse(date)
		)
		subject
	end

	def three_subjects_with_sent_to_subject_on
		create_subjects_with_sent_to_subject_on(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_subject_with_received_by_ccls_on(date)
		subject = create_hx_subject
		Factory(:sample,
			:subject => subject,
			:sent_to_subject_on  => (Chronic.parse(date) - 2000000),
			:collected_on  => (Chronic.parse(date) - 1000000),
			:received_by_ccls_on => Chronic.parse(date)
		)
		subject
	end

	def three_subjects_with_received_by_ccls_on
		create_subjects_with_received_by_ccls_on(
			'12/31/2005','12/31/2001','12/31/2003')
	end


	def create_gift_cards(count=0,options={})
		gift_cards = []
		count.times{ gift_cards.push(create_gift_card(options)) }
		return gift_cards
	end

	def create_gift_card_with_first_name(first_name)
		subject = create_subject_with_first_name(first_name)
		gift_card = create_gift_card
		subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_last_name(last_name)
		subject = create_subject_with_last_name(last_name)
		gift_card = create_gift_card
		subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_childid(childid)
		subject = create_subject_with_childid(childid)
		gift_card = create_gift_card
		subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_patid(patid)
		subject = create_subject_with_patid(patid)
		gift_card = create_gift_card
		subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_number(number)
		create_gift_card(:number => number)
	end




	def create_case_subject_with_patid(patid)
#		subject = create_subject( :subject_type => SubjectType['Case'] )
#		Factory(:identifier,
#			:subject => subject,
#			:patid   => patid.to_s )
#		subject
		subject = create_subject( 
			:subject_type => SubjectType['Case'],
			:identifier_attributes => Factory.attributes_for(:identifier,
				:patid   => patid.to_s )
		)
	end

	def create_abstracts(count=0,options={})
		abstracts = []
		count.times{ abstracts.push(create_abstract(options)) }
		return abstracts
	end

	def create_abstract_with_first_name(first_name)
		subject  = create_subject_with_first_name(first_name)
		abstract = create_abstract
		subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_last_name(last_name)
		subject  = create_subject_with_last_name(last_name)
		abstract = create_abstract
		subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_childid(childid)
		subject  = create_subject_with_childid(childid)
		abstract = create_abstract
		subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_patid(patid)
		subject  = create_subject_with_patid(patid)
		abstract = create_abstract
		subject.abstracts << abstract
		abstract
	end


	
#########

	def method_missing_with_pluralization(symb,*args, &block)
		method_name = symb.to_s
		if method_name =~ /^create_(.*)_with_(.*)$/
			model     = $1.singularize
			attribute = $2.singularize
			args.collect do |arg|
				send("create_#{model}_with_#{attribute}",arg)
			end
		else
			method_missing_without_pluralization(symb, *args, &block)
		end
	end

	def self.included(base)
		base.alias_method_chain( :method_missing, :pluralization 
			) unless base.respond_to?(:method_missing_without_pluralization)
	end

end
ActiveSupport::TestCase.send(:include, Ccls::FactoryTestHelper)
