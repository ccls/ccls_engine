module Ccls::FactoryTestHelper

	def create_home_exposure_with_study_subject(options={})
		study_subject = identifier = project = nil
		unless options[:patient].nil?
			options[:study_subject] ||= {}
			options[:study_subject][:subject_type] = SubjectType['Case']
		end
		assert_difference('StudySubject.count',1) {
			study_subject    = Factory(:study_subject,options[:study_subject]||{})
		}
		assert_difference('StudySubject.count',0) {
		assert_difference('Identifier.count',1) {
			identifier = Factory(:identifier, 
				(options[:identifier]||{}).merge(
					:study_subject => study_subject))
		} }
		project = Project.find_or_create_by_code('HomeExposures')
		assert_not_nil project
		assert_difference('StudySubject.count',0) {
		assert_difference('Identifier.count',0) {
		assert_difference('Enrollment.count',1) {
			Factory(:enrollment, (options[:enrollment]||{}).merge(
				:study_subject => study_subject, :project => project ))
		} } }
		unless options[:patient].nil?
			assert_difference('StudySubject.count',0) {
			assert_difference('Patient.count',1) {
				Factory(:patient, :study_subject => study_subject )
			} }
		end
		study_subject
	end
	alias_method :create_hx_study_subject, :create_home_exposure_with_study_subject

	def create_eligible_hx_study_subject()
		study_subject = nil
		assert_nil study_subject
		assert_difference('Enrollment.count',1) {
		assert_difference('StudySubject.count',1) {
			study_subject = create_hx_study_subject(:enrollment => {
				:is_eligible => YNDK[:yes] })
		} }
		assert_not_nil study_subject
		assert_study_subject_is_eligible(study_subject)
		study_subject
	end

	def create_hx_interview_study_subject(options={})
		study_subject = create_hx_study_subject
		instrument = Factory(:instrument, 
			:project => Project.find_or_create_by_code('HomeExposures'))
		instrument_version = Factory(:instrument_version, 
			:instrument => instrument)
		interview = Factory(:interview, 
			:study_subject => study_subject,
			:instrument_version => instrument_version)
		study_subject
	end

	def create_study_subject(options = {})
		#	May contain options for testing failing so can't assert
		#	that StudySubject.count will change here.
		record = Factory.build(:study_subject,options)
		record.save
		record
	end

	def create_study_subjects(count=0,options={})
		study_subjects = []
		count.times{ study_subjects.push(create_study_subject(options)) }
		return study_subjects
	end

	def create_study_subjects_with_recruitment_priorities(*priorities)
		project = nil
		assert_difference('Project.count',1) {
			project = Factory(:project)
		}
		study_subjects = priorities.collect do |priority|
			study_subject = nil
			assert_difference('StudySubject.count',1) {
				study_subject = create_study_subject
			}
			assert_difference('Enrollment.count',1){
				Factory(:enrollment, :project => project, 
					:study_subject => study_subject,
					:recruitment_priority => priority)
			}
			study_subject
		end
		return [project,*study_subjects]
	end

	def create_study_subject_with_gift_card_number(gift_card_number)
		study_subject = create_study_subject
		Factory(:gift_card, 
			:study_subject => study_subject,
			:number  => gift_card_number )
		study_subject
	end

	def create_study_subjects_with_races(count=0,options={})
		study_subjects = create_study_subjects(count)
		study_subjects.each{|s|s.races << Factory(:race)}
		study_subjects
	end

	def create_study_subject_with_childid(childid)
		Identifier.any_instance.stubs(:get_next_childid).returns(childid)
		identifier = Factory(:identifier)
		Identifier.any_instance.unstub(:get_next_childid)
		assert_not_nil identifier.childid
		assert_equal childid.to_s, identifier.childid.to_s
		identifier.study_subject
	end

	def three_study_subjects_with_childid
		create_study_subjects_with_childids(9,3,6)
	end

	def create_study_subject_with_patid(patid)
		identifier = Factory(:identifier)	#not case so shouldn't create patid
		assert_nil     identifier.patid
		identifier.update_attribute(:patid, patid)
		assert_not_nil identifier.patid
		assert_equal patid.to_s, identifier.patid.to_s
		identifier.study_subject
	end
	alias_method :create_study_subject_with_studyid, :create_study_subject_with_patid

	def three_study_subjects_with_patid
		create_study_subjects_with_patids(9,3,6)
	end
	alias_method :three_study_subjects_with_studyid,       :three_study_subjects_with_patid

	def create_study_subject_with_last_name(last_name)
		create_study_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:last_name => last_name ))
	end
	
	def three_study_subjects_with_last_name
		create_study_subjects_with_last_names('9','3','6')
	end

	def create_study_subject_with_first_name(first_name)
		create_study_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:first_name => first_name ))
	end
	
	def three_study_subjects_with_first_name
		create_study_subjects_with_first_names('9','3','6')
	end

	def create_study_subject_with_dob(dob)
		create_study_subject(
			:pii_attributes => Factory.attributes_for(:pii, 
				:dob => Time.parse(dob) ))
	end

	def three_study_subjects_with_dob
		create_study_subjects_with_dobs(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_study_subject_with_sample_outcome_on(date)
		s = create_hx_study_subject
		s.update_attributes( 
			:homex_outcome_attributes => Factory.attributes_for(:homex_outcome,
				:sample_outcome_on => date) )
		s
	end

	def three_study_subjects_with_sample_outcome_on
		create_study_subjects_with_sample_outcome_ons(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_study_subject_with_sample_outcome(outcome)
		s = create_hx_study_subject
		s.update_attributes( 
			:homex_outcome_attributes => Factory.attributes_for(:homex_outcome,
				:sample_outcome_id => outcome) )
		s
	end

	def three_study_subjects_with_sample_outcome
		create_study_subjects_with_sample_outcomes('9','3','6')
	end

	def create_study_subject_with_interview_outcome_on(date)
		create_hx_study_subject(:study_subject => {
			:homex_outcome_attributes => Factory.attributes_for(:homex_outcome,
				:interview_outcome_on => date ) })
	end

	def three_study_subjects_with_interview_outcome_on
		create_study_subjects_with_interview_outcome_ons(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_study_subject_with_sent_to_subject_on(date)
		study_subject = create_hx_study_subject
		Factory(:sample,
			:study_subject => study_subject,
			:sent_to_subject_on => Chronic.parse(date)
		)
		study_subject
	end

	def three_study_subjects_with_sent_to_subject_on
		create_study_subjects_with_sent_to_subject_on(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_study_subject_with_received_by_ccls_on(date)
		study_subject = create_hx_study_subject
		Factory(:sample,
			:study_subject => study_subject,
			:sent_to_subject_on  => (Chronic.parse(date) - 2000000),
			:collected_on  => (Chronic.parse(date) - 1000000),
			:received_by_ccls_on => Chronic.parse(date)
		)
		study_subject
	end

	def three_study_subjects_with_received_by_ccls_on
		create_study_subjects_with_received_by_ccls_on(
			'12/31/2005','12/31/2001','12/31/2003')
	end

	def create_gift_cards(count=0,options={})
		gift_cards = []
		count.times{ gift_cards.push(create_gift_card(options)) }
		return gift_cards
	end

	def create_gift_card_with_first_name(first_name)
		study_subject = create_study_subject_with_first_name(first_name)
		gift_card = create_gift_card
		study_subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_last_name(last_name)
		study_subject = create_study_subject_with_last_name(last_name)
		gift_card = create_gift_card
		study_subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_childid(childid)
		study_subject = create_study_subject_with_childid(childid)
		gift_card = create_gift_card
		study_subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_patid(patid)
		study_subject = create_study_subject_with_patid(patid)
		gift_card = create_gift_card
		study_subject.gift_cards << gift_card
		gift_card
	end
	
	def create_gift_card_with_number(number)
		create_gift_card(:number => number)
	end

	def create_case_study_subject_with_patid(patid)
		Identifier.any_instance.stubs(:get_next_patid).returns(patid)
		study_subject = create_study_subject( 
			:subject_type => SubjectType['Case'],
			:identifier_attributes => Factory.attributes_for(:identifier,
				:case_control_type => 'c')
		)
		Identifier.any_instance.unstub(:get_next_patid)
		study_subject.reload
	end

	def create_abstracts(count=0,options={})
		abstracts = []
		count.times{ abstracts.push(create_abstract(options)) }
		return abstracts
	end

	def create_abstract_with_first_name(first_name)
		study_subject  = create_study_subject_with_first_name(first_name)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_last_name(last_name)
		study_subject  = create_study_subject_with_last_name(last_name)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_childid(childid)
		study_subject  = create_study_subject_with_childid(childid)
		abstract = create_abstract
		study_subject.abstracts << abstract
		abstract
	end

	def create_abstract_with_patid(patid)
		study_subject  = create_study_subject_with_patid(patid)
		abstract = create_abstract
		study_subject.abstracts << abstract
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
