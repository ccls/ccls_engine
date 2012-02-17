namespace :db do

#	desc "Import subject and address data from CSV files"
#	task :import_csv_data => [
#		:destroy_csv_data,
#		:import_subject_data,
#		:import_matchingid_and_familyid,
#		:import_address_data,
#		:random_enrollments_data
#	]

	desc "Destroy subject and address data"
	task :destroy_csv_data => :environment do
		StudySubject.destroy_all
		Enrollment.destroy_all
		Addressing.destroy_all
		Address.destroy_all
		PhoneNumber.destroy_all
		Interview.destroy_all
#		Identifier.destroy_all
		Patient.destroy_all
#		Pii.destroy_all
#		ResponseSet.destroy_all
#		Response.destroy_all
		Sample.destroy_all
		SampleKit.destroy_all
#		Package.destroy_all
		HomexOutcome.destroy_all
		InterviewOutcome.destroy_all
		HomeExposureResponse.destroy_all
		OperationalEvent.destroy_all
		ProjectOutcome.destroy_all
		SampleOutcome.destroy_all
#		Track.destroy_all
		Transfer.destroy_all
#		SurveyInvitation.destroy_all
	end

	task :random_enrollments_data => :environment do 
		p = Project.find_or_create_by_code({
			:code => "HomeExposures",
			:description => "HomeExposures"
		})
		StudySubject.all.each do |s|
			puts s.id
			#	2440000 is sometime in 1968
			#	2455000 is sometime in 2009

			options = {
				:study_subject => s,
				:project => p,
				:is_candidate => true,
				:able_to_locate => true
			}
			options[:is_eligible] = [nil,1,2,999][rand(4)]
			if options[:is_eligible] == 2
				ir = IneligibleReason.random()
				options[:ineligible_reason_id] = ir.id
				if ir.is_other?
					options[:ineligible_reason_specify] = "Random reason ineligible"
				end
			end

			options[:is_chosen] = [nil,1,2,999][rand(4)]
			if options[:is_chosen] == 2
				options[:reason_not_chosen] = "Random reason not chosen"
			end

			options[:consented] = [nil,1,2,999][rand(4)]
			if options[:consented] == 1
				options[:consented_on] = Date.jd(2440000+rand(15000))
			elsif options[:consented] == 2
				options[:consented_on] = Date.jd(2440000+rand(15000))
				rr = RefusalReason.random()
				options[:refusal_reason_id] = rr.id
				if rr.is_other?
					options[:other_refusal_reason] = "Random refusal reason"
				end
			end

			options[:terminated_participation] = [nil,1,2,999][rand(4)]
			if options[:terminated_participation] == 1
				options[:terminated_reason] = "Random terminated reason"
			end

			options[:is_complete] = [nil,1,2,999][rand(4)]
			if options[:is_complete] == 1
				options[:completed_on] = Date.jd(2440000+rand(15000))
			end
			Enrollment.create!(options)


			options = {
				:interview_outcome => InterviewOutcome.random(),
				:sample_outcome => SampleOutcome.random()
			}
			if options[:interview_outcome]
				options[:interview_outcome_on] = Date.jd(2440000+rand(15000))
			end
			if options[:sample_outcome]
				options[:sample_outcome_on] = Date.jd(2440000+rand(15000))
			end
			s.build_homex_outcome(options)
			s.save!
		end
	end

#	desc "Import subject data from CSV file"
#	task :import_subjectid => :environment do
#		require 'fastercsv'
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open('misc/dummy_subject_pii_etc.csv', 'rb',{
#			:headers => true })).each do |line|
##	Childid,patID,Type,OrderNo,subjectID,sex,DOB,RefDate,InterviewDate,First_Name,Middle_Name,Last_Name,Mother_First_Name,Mother_Middle_Name,Mother_Maiden_Name,Mother_Last_Name,Father_First_Name,Father_Middle_Name,Father_Last_Name,Primary_Phone,Alternate_phone1,Alternate_phone2,Alternate_phone3
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	due to padding it with zeros, NEED this to be an Integer
#			#	doesn't work correctly in sqlite so just pad it before search
#			identifier = Identifier.find_by_childid(
#				sprintf("%06d",line['Childid'].to_i))
#			raise ActiveRecord::RecordNotFound unless identifier
#
#			identifier.update_attributes!(:subjectid => line['subjectID'])
#
#		end
#	end
#
#	desc "Import matchingid and familyid data from CSV file"
#	task :import_matchingid_and_familyid => :environment do
#		require 'fastercsv'
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open('misc/subjectmatchingfamilyids_xref.csv', 'rb',{
#			:headers => true })).each do |line|
##	subjectID,matchingID,familyid
#			puts "Processing line #{f.lineno}"
#			puts line
#			if line['subjectID'] =~ /^\s*#/
#				puts "skipping as subjectid not found"
#				next 
#			end
#
#			#	due to padding it with zeros, NEED this to be an Integer
#			#	doesn't work correctly in sqlite so just pad it before search
#			identifier = Identifier.find_by_subjectid(
#				sprintf("%06d",line['subjectID'].to_i))
#			raise ActiveRecord::RecordNotFound unless identifier
#
#			identifier.update_attributes!(
#				:matchingid => line['matchingID'],
#				:familyid   => line['familyid']
#			)
#
#		end
#	end
#
#	desc "Import address data from CSV file"
#	task :import_address_data => :environment do
#		require 'fastercsv'
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open('misc/dummy_addresses.csv', 'rb',{
#			:headers => true })).each do |line|
##	subjectID,Address_Type_ID,Address_Line1,Address_City,Address_State,Address_Zip
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	due to padding it with zeros, NEED this to be an Integer
#			#	doesn't work correctly in sqlite so just pad it before search
#			study_subject = Identifier.find_by_subjectid(
#				sprintf("%06d",line['subjectID'].to_i)).study_subject
#			raise ActiveRecord::RecordNotFound unless study_subject
#
##			address_type = AddressType.find(line[1].to_s)
##			address_type = AddressType.find_by_code(
##				(line[1].to_s == '1')?'Home':'Mailing')
##			raise ActiveRecord::RecordNotFound unless address_type
#
##			study_subject.addressings << Addressing.create!(
##				:study_subject_id  => study_subject.id,
#			study_subject.addressings.create!(
#				:current_address => 1,		#	Yes
#				:is_valid    => true,
#				:is_verified => false,
#				:address_attributes => {
#					:address_type_id => line['Address_Type_ID'].to_i,
#					:line_1 => line['Address_Line1']||"FAKE LINE 1",
#					:city => line['Address_City']||"FAKE CITY",
#					:state => line['Address_State']||"FAKE STATE",
#					:zip => line['Address_Zip']||"12345-6789"
#				}
#			)
#		end
#	end
#
#	desc "Import subject data from CSV file"
#	task :import_subject_data => :environment do
#		require 'fastercsv'
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open('misc/dummy_subject_pii_etc.csv', 'rb',{
#			:headers => true })).each do |line|
##	Childid,patID,Type,OrderNo,subjectID,sex,DOB,RefDate,InterviewDate,First_Name,Middle_Name,Last_Name,Mother_First_Name,Mother_Middle_Name,Mother_Maiden_Name,Mother_Last_Name,Father_First_Name,Father_Middle_Name,Father_Last_Name,Primary_Phone,Alternate_phone1,Alternate_phone2,Alternate_phone3
#			puts "Processing line #{f.lineno}"
#			puts line
#
##			subject_type = SubjectType['Case']
#			subject_type = SubjectType.random()
#
#			#	TODO	(not included in csv)
##			race = Race[1]
#			race = Race.random()
#
#			dob = (line['DOB'].blank?)?'':Time.parse(line['DOB'])
#			refdate = (line['RefDate'].blank?)?'':Time.parse(line['RefDate'])
#			interview_date = (line['InterviewDate'].blank?)?'':Time.parse(line['InterviewDate'])
#			study_subject = StudySubject.create!({
##				:patient_attributes  => { },										#	TODO (patid)
#				:pii_attributes => {
#					:first_name  => line['First_Name'],
#					:middle_name => line['Middle_Name'],
#					:last_name   => line['Last_Name'],
#					:father_first_name  => line['Father_First_Name'],
#					:father_middle_name => line['Father_Middle_Name'],
#					:father_last_name   => line['Father_Last_Name'],
#					:mother_first_name  => line['Mother_First_Name'],
#					:mother_middle_name => line['Mother_Middle_Name'],
#					:mother_maiden_name => line['Mother_Maiden_Name'],
#					:mother_last_name   => line['Mother_Last_Name'],
#					:dob => dob
#				},
#				:identifier_attributes => {
#					:state_id_no       => sprintf('%09d',line['Childid']),			#	TODO
#					:subjectid         => line['subjectID'],
#					:ssn               => sprintf('%09d',line['Childid']),							#	TODO
#					:patid             => line['patID'],
#					:case_control_type => line['Type'],
#					:orderno           => line['OrderNo'],
#					:childid           => line['Childid'] 
#				},
#				:subject_type => subject_type,
#				:sex => line['sex'],
#				:reference_date => refdate
#			})
#			study_subject.races = [race]
#
##			Identifier.create!({
##					:study_subject_id        => study_subject.id,
##					:state_id_no       => sprintf('%09d',line['Childid']),			#	TODO
##					:subjectid         => line['subjectID'],
##					:ssn               => sprintf('%09d',line['Childid']),							#	TODO
##					:patid             => line['patID'],
##					:case_control_type => line['Type'],
##					:orderno           => line['OrderNo'],
##					:childid           => line['Childid'] 
##				})
#
#			(19..22).each do |i|
##				PhoneNumber.create!({
#				study_subject.phone_numbers.create!({
##					:study_subject_id    => study_subject.id,
#					:phone_type_id => 1,
#					:phone_number  => line[i]
#				}) unless line[i].blank?
#			end
#
#			options = {
##				:identifier_id => study_subject.identifier.id,
#				:interview_method => InterviewMethod.random(),
#				:interviewer => Person.random(),
#				:language   => Language.random(),
#				:instrument_version => InstrumentVersion.random(),
#				:began_on   => interview_date,
#				:ended_on   => interview_date
#			}
#			options[:subject_relationship] = SubjectRelationship.random()
#			if options[:subject_relationship].is_other?
#				options[:subject_relationship_other] = 'super unknown god buddy'
#			end
#			
##			Interview.create!(options)
#			study_subject.interviews.create!(options)
#			
##	use Time.parse to parse all dates (better than Date.parse)
#
##	need ssn, state_id_no in data (making it up now)
#
#		end
#	end
end
