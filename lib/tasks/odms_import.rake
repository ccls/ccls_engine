require 'fastercsv'
require 'chronic'

#BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/Database/DataLists/jake/"
#BASEDIR = "/Volumes/BUF-Fileshare/RestrictedData/StaffFolders/WendtJake/HomeExposuresImport_20110504/"
#BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/Database/DataLists/HomeExposuresImport_20110504/"
BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/DataMigration/"
#ODMS_SubjectData_Combined_092611.csv

namespace :odms_destroy do

	desc "Destroy subject and address data"
	task :csv_data => :environment do
		puts "Destroying existing data"
		StudySubject.destroy_all
		Enrollment.destroy_all
		Addressing.destroy_all
		Address.destroy_all
		PhoneNumber.destroy_all
		Interview.destroy_all
		Identifier.destroy_all
		Patient.destroy_all
		Pii.destroy_all
		Sample.destroy_all
		SampleKit.destroy_all
		Package.destroy_all
		HomexOutcome.destroy_all
		HomeExposureResponse.destroy_all
	end

end


namespace :odms_import do

	desc "Import subject and address data from CSV files"
	task :csv_data => [
#		'odms_destroy:csv_data',	#	change to other shared database to test
		'odms_import:subjects'
	]

	desc "Import data from subjects.csv file"
	task :subjects => :environment do
		puts "Importing subjects"

		error_file = File.open('subjects_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("#{BASEDIR}/ODMS_SubjectData_Combined_092611.csv", 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#	subjectID,subjectType_id,vital_status_id,do_not_contact,sex,refdate,ChildId,icf_master_id,matchingID,familyID,PatID,case_control_type,OrderNo,newID,studyID,related_case_childID,state_id_no,subject_type_id,admit_date,diagnosis_id,organization_id,ODMS_Patients_092611.created_at,was_previously_treated,was_under_15_at_dx,Zipcode,County,first_name,middle_name,last_name,maiden_name,dob,died_on,mother_first_name,mother_maiden_name,mother_last_name,father_first_name,father_last_name,ODMS_Identifiers_092611.created_at

#			pii = Pii.new do |m|
#			end
#			identifier = Identifier.new do |m|
#			end
#			attributes = {
#				:subject_type_id => 
#				:vital_status_id => 
#				:pii => pii,
#				:identifier => identifier
#			}
#
#			if is a patient build patient attributes
#
#			StudySubject.create!(attributes)

		end	#	FasterCSV.open
		error_file.close

		printf "%-19s %5d\n", "StudySubject.count:", StudySubject.count
		printf "%-19s %5d\n", "Identifier.count:", Identifier.count
		printf "%-19s %5d\n", "Pii.count:", Pii.count
		printf "%-19s %5d\n", "Patient.count:", Patient.count
	end		#	task :subjects => :environment do


#	desc "Import data from homex_identifiers.csv file"
#	task :homex_identifiers => :environment do
#		puts "Importing homex_identifiers"
#
#		error_file = File.open('homex_identifiers_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_identifiers.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"childIDWho","childID","subjectID","familyid","matchingid","PatID",
#			#		"case_control_type","OrderNo","StudyID","newID","subjectType","GBID",
#			#		"lab_no","lab_no_wiemels","IDNO_wiemels","accession_no","state_id_no",
#			#		"studyID_noHyphen","studyID_intOnly_noHyphen","icf_master_id","hospital_no"
#
#			#	case_control_type and subjectType are the same
#
#			attributes = {
#				:childidwho => line['childIDWho'],
#				:childid => line['childID'],
#				:subjectid => line['subjectID'],
#				:familyid => line['familyid'],
#				:matchingid => line['matchingid'],
#				:patid => line['PatID'],
#				:case_control_type => line['case_control_type'],
#				:orderno => line['OrderNo'],
#				:studyid => line['StudyID'],
#				:newid => line['newID'],
#				:gbid => line['GBID'],
#				:lab_no => line['lab_no'],
#				:lab_no_wiemels => line['lab_no_wiemels'],
#				:idno_wiemels => line['IDNO_wiemels'],
#				:accession_no => line['accession_no'],
#				:state_id_no => line['state_id_no'],
#				:studyid_nohyphen => line['studyID_noHyphen'],
#				:studyid_intonly_nohyphen => line['studyID_intOnly_noHyphen'],
#				:icf_master_id => line['icf_master_id'],
#				:hospital_no => line['hospital_no']
#			}
#			Identifier.create!(attributes)
#
##			identifier = Identifier.create(attributes)
##			if identifier.new_record?
##				error_file.puts line
##				error_file.puts identifier.errors.full_messages.to_sentence
##				error_file.puts
##			end
#
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_identifiers => :environment do
#
#
#	desc "Import data from homex_subjects.csv file"
#	task :homex_subjects => :environment do
#		puts "Importing homex_subjects"
#
#		error_file = File.open('homex_subjects_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_subjects.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"ChildId","subjectID","reference_date","sex","created_at",
#			#		"vital_status_id","subject_type_id","race_id","DoNotContact"
#
#			created_at = (line['created_at'].blank?) ? nil : Time.parse(line['created_at'])
#			reference_date = (line['reference_date'].blank?) ? nil : Time.parse(line['reference_date'])
#			attributes = {
#				:reference_date => reference_date,
#				:sex => line['sex'],
#				:created_at => created_at,
#				:vital_status_id => line['vital_status_id'],
#				:subject_type_id => line['subject_type_id'],
#				:do_not_contact => line['DoNotContact']
#			}
#			study_subject = StudySubject.create!(attributes)
#
##			identifier = Identifier.find_by_childid(line['ChildId'])
#			identifier = Identifier.find_by_subjectid(sprintf("%06d",line['subjectID'].to_i))
#			unless identifier
#				error_file.puts line
#				error_file.puts "No identifier found with subjectID = #{line['subjectID']}" 
#				error_file.puts
#			else
#				identifier.study_subject = study_subject
#				identifier.save!
#			end
#
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_subjects => :environment do
#  	  	
#
#	desc "Import data from homex_piis.csv file"
#	task :homex_piis => :environment do
#		puts "Importing homex_piis"
#
#		error_file = File.open('homex_piis_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_piis.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"childID","subjectID","study_subject_id","first_name","middle_name",
#			#		"last_name","dob","died_on","state_id_no","mother_first_name",
#			#		"mother_middle_name","mother_last_name","mother_maiden_name",
#			#		"father_first_name","father_middle_name","father_last_name","email"
#
#			dob     = (line['dob'].blank?)     ? nil : Time.parse(line['dob'])
#			died_on = (line['died_on'].blank?) ? nil : Time.parse(line['died_on'])
#			attributes = {
#				:dob => dob,
#				:died_on => died_on,
#				:first_name => line['first_name'],
#				:middle_name => line['middle_name'],
#				:last_name => line['last_name'],
#				:mother_first_name => line['mother_first_name'],
#				:mother_middle_name => line['mother_middle_name'],
#				:mother_last_name => line['mother_last_name'],
#				:mother_maiden_name => line['mother_maiden_name'],
#				:father_first_name => line['father_first_name'],
#				:father_middle_name => line['father_middle_name'],
#				:father_last_name => line['father_last_name'],
#				:email => line['email'],
#			}
#			pii = Pii.create!(attributes)
#
##			identifier = Identifier.find_by_childid(line['childID'])
#			identifier = Identifier.find_by_subjectid(sprintf("%06d",line['subjectID'].to_i))
#			unless identifier
#				error_file.puts line
#				error_file.puts "No identifier found with subjectID = #{line['subjectID']}" 
#				error_file.puts
#			else
#				pii.study_subject = identifier.study_subject
#				pii.save!
#			end
#
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_piis => :environment do
#
#
#
#	desc "Import data from homex_enrollments.csv file"
#	task :homex_enrollments => :environment do
#		puts "Importing homex_enrollments"
#
#		error_file = File.open('homex_enrollments_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_enrollments.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"id","study_subject_id","project_id","recruitment_priority","able_to_locate",
#			#		"is_candidate","is_eligible","ineligible_reason_id","ineligible_reason_specify",
#			#		"consented","consented_on","refusal_reason_id","other_refusal_reason","is_chosen",
#			#		"reason_not_chosen","terminated_participation","terminated_reason","is_complete",
#			#		"completed_on","is_closed","reason_closed","notes","created_at","updated_at",
#			#		"document_version_id","project_outcome_id","project_outcome_on",
#			#		"childID-deleteme","problem","search_outcome","letter_outcome"
#
#			consented_on       = (line['consented_on'].blank?)     ? 
#				nil : Time.parse(line['consented_on'])
#			completed_on       = (line['completed_on'].blank?) ? 
#				nil : Time.parse(line['completed_on'])
#			project_outcome_on = (line['project_outcome_on'].blank?) ? 
#				nil : Time.parse(line['project_outcome_on'])
#			attributes = {
#				:project_id                => line['project_id'],
#				:recruitment_priority      => line['recruitment_priority'],
#				:able_to_locate            => line['able_to_locate'],
#				:is_candidate              => line['is_candidate'],
#				:is_eligible               => line['is_eligible'],
#				:ineligible_reason_id      => line['ineligible_reason_id'],
#				:ineligible_reason_specify => line['ineligible_reason_specify'],
#				:consented                 => line['consented'],
#				:consented_on              => consented_on,
#				:refusal_reason_id         => line['refusal_reason_id'],
#				:other_refusal_reason      => line['other_refusal_reason'],
#				:is_chosen                 => line['is_chosen'].try(:gsub,/^-/,''),		#	were -1
#				:reason_not_chosen         => line['reason_not_chosen'],
#				:terminated_participation  => line['terminated_participation'],
#				:terminated_reason         => line['terminated_reason'],
#				:is_complete               => line['is_complete'],
#				:completed_on              => completed_on,
#				:is_closed                 => line['is_closed'],
#				:reason_closed             => line['reason_closed'],
#				:notes                     => line['notes'],
#				:document_version_id       => line['document_version_id'],
#				:project_outcome_id        => line['project_outcome_id'],
#				:project_outcome_on        => project_outcome_on
#			#		"childID-deleteme","problem","search_outcome","letter_outcome"
#			}
#			if attributes[:is_complete] && attributes[:completed_on].blank?
#				attributes[:completed_on] = Chronic.parse("01/01/1900")
#			end
##			if attributes[:consented] && attributes[:consented_on].blank?
##				attributes[:consented_on] = Date.today 
##			end
##			if attributes[:is_eligible] == '2' && attributes[:ineligible_reason_id].blank?
##				attributes[:ineligible_reason_id] = IneligibleReason['legacy'].id
##puts "Manually setting ineligible reason"
##puts IneligibleReason['legacy'].inspect
##			end
##			if attributes[:consented] == '2' && attributes[:refusal_reason_id].blank?
##				attributes[:refusal_reason_id] = RefusalReason['other'].id
##			end
#			if attributes[:refusal_reason_id] == '7' && attributes[:other_refusal_reason].blank?
#				attributes[:other_refusal_reason] = "unknown at legacy data import"
#			end
#
#			identifier = Identifier.find_by_subjectid(sprintf("%06d",line['subjectID'].to_i))
#			unless identifier
#				error_file.puts line
#				error_file.puts "No identifier found with subjectID = #{line['subjectID']}" 
#				error_file.puts "Enrollment creation not attempted"
#				error_file.puts
#			else
#				enrollment = identifier.study_subject.enrollments.create!(attributes)
##				enrollment = identifier.study_subject.enrollments.new(attributes)
##	many won't be valid, so skip validations
##				enrollment.save(false)
#			end
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_enrollments => :environment do
#
#
#	desc "Import data from homex_addresses.csv file"
#	task :homex_addresses => :environment do
#		puts "Importing homex_addresses"
#
#		error_file = File.open('homex_addresses_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_addresses.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"ID","Review","ReviewNotes","DataSource","AddressType","ChildID","Street","City",
#			#		"State","Zipcode","FIPSCountyCode","County","Original","Interview","IsCurrent",
#			#		"StartDate","EndDate","EntryDate","T2KAddressID","childID-deleteme","study_subject_id"
#
#			valid_from = (line['StartDate'].blank?)     ? 
#				nil : Time.parse(line['StartDate'])
#			valid_to   = (line['EndDate'].blank?)     ? 
#				nil : Time.parse(line['EndDate'])
#
#			attributes = {
#			#	"ID","Review","ReviewNotes","DataSource",
#			#		"FIPSCountyCode","Original","Interview",
#			#		"EntryDate","T2KAddressID"
#				:address_attributes => {
#					:address_type_id => AddressType[line['AddressType'].downcase].id,
#					:line_1          => line['Street'],
#					:city            => line['City'],
#					:state           => line['State'],
#					:zip             => line['Zipcode'],
#					:county          => line['County'],
#				},
#				:current_address => line['IsCurrent'],
#				:valid_from      => valid_from,
#				:valid_to        => valid_to
#			}
#
##			if attributes[:address_attributes][:city].blank?
##				attributes[:address_attributes][:city] = "NoneGiven"
##			end
##			if attributes[:address_attributes][:state].blank?
##				attributes[:address_attributes][:state] = "NoneGiven"
##			end
##			if attributes[:address_attributes][:zip].blank?
##				attributes[:address_attributes][:zip] = "00000"
##			end
#
#			identifier = Identifier.find_by_childid(line['ChildID'])
#			unless identifier
#				error_file.puts line
#				error_file.puts "No identifier found with childid = #{line['ChildID']}" 
#				error_file.puts "Addressing creation not attempted"
#				error_file.puts
#			else
##				addressing = identifier.study_subject.addressings.create!(attributes)
#				addressing = identifier.study_subject.addressings.new(attributes)
##	one won't be valid, so skip validations for all
#				addressing.save(false)
#			end
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_addresses => :environment do
#
#
#  	  	
#	desc "Import data from homex_interviews.csv file"
#	task :homex_interviews => :environment do
#		puts "Importing homex_interviews"
#
#		error_file = File.open('homex_interviews_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_interviews.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"subjectID","Questionnaire","began_on","ended_on","consented_on",
#			#		"intro letter sent","instrument_version_id","interview_method_id"
#
#			began_on = (line['began_on'].blank?) ? 
#				nil : Time.parse(line['began_on'])
#			ended_on = (line['ended_on'].blank?) ? 
#				nil : Time.parse(line['ended_on'])
#			consented_on = (line['consented_on'].blank?) ? 
#				nil : Time.parse(line['consented_on'])
#			letter_sent_on = (line['intro letter sent'].blank?) ? 
#				nil : Time.parse(line['intro letter sent'])
#
#			attributes = {
#				:began_on => began_on,
#				:ended_on => ended_on,
##				:consented_on => consented_on,
#				:intro_letter_sent_on => letter_sent_on,
#				:instrument_version_id => line['instrument_version_id'],
#				:interview_method_id => line['interview_method_id']
#			}
#
#			identifier = Identifier.find_by_subjectid(sprintf("%06d",line['subjectID'].to_i))
#			unless identifier
#				error_file.puts line
#				error_file.puts "No identifier found with subjectid = #{line['subjectID']}" 
#				error_file.puts
#			else
#				identifier.study_subject.interviews.create!(attributes)
#			end
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_interviews => :environment do
#
#
#	desc "Import data from homex_outcomes.csv file"
#	task :homex_outcomes => :environment do
#		puts "Importing homex_outcomes"
#
#		error_file = File.open('homex_outcomes_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/homex_outcomes.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"id","position","childID","subjectid","sample_outcome_id","sample_outcome_on",
#			#		"interview_outcome_id","interview_outcome_on","created_at","updated_at"
#			sample_outcome_on = (line['sample_outcome_on'].blank?) ? 
#				nil : Time.parse(line['sample_outcome_on'])
#			interview_outcome_on = (line['interview_outcome_on'].blank?) ? 
#				nil : Time.parse(line['interview_outcome_on'])
#
#			attributes = {
#				:sample_outcome_id => line['sample_outcome_id'],
#				:sample_outcome_on => sample_outcome_on,
#				:interview_outcome_id => line['interview_outcome_id'],
#				:interview_outcome_on => interview_outcome_on
#			}
#
#			identifier = Identifier.find_by_subjectid(sprintf("%06d",line['subjectid'].to_i))
#			unless identifier
#				error_file.puts line
#				error_file.puts "No identifier found with subjectid = #{line['subjectid']}" 
#				error_file.puts
#			else
#				identifier.study_subject.create_homex_outcome(attributes) or raise "homex_outcome create failed"
#			end
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :homex_outcomes => :environment do



































  	  	

######################################################################
#
#	desc "Import data from contacts.csv file"
#	task :contacts => :environment do
#		puts "Importing contacts"
#
#		error_file = File.open('contacts_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/contacts.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"ID","Review","ReviewNotes","DataSource","AddressType","ChildID","Street","City",
#			#		"State","Zipcode","FIPSCountyCode","County","Original","Interview","IsCurrent",
#			#		"StartDate","EndDate","EntryDate","T2KAddressID","childID-deleteme",
#			#		"study_subject_id","t2k_primary_phone","t2k_alt_phone","src_primary_phone",
#			#		"src_alt_phone_1","src_alt_phone_2","src_alt_phone_3"
#
#
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :contacts => :environment do
#
#
#	desc "Import data from subjects.csv file"
#	task :subjects => :environment do
#		puts "Importing subjects"
#
#		error_file = File.open('subjects_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/subjects.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"study_subject_id","newID","subjectID","childID","Who","subjectType","relatedPatID",
#			#		"matchingID","familyID","relatedChildID","T2K_subjectsTableID"
#
#			attributes = {
#				:identifier_attributes => {
#					:childid           => line['childID'],
#					:subjectid         => line['subjectID'],
#					:matchingid        => line['matchingID'],
#					:familyid          => line['familyID'],
#					:case_control_type => line['subjectType'],
#					:related_childid   => line['relatedChildID']
#				}
#			}
#			StudySubject.create!(attributes)
#
#
#		end	#	FasterCSV.open
#		error_file.close
#	end		#	task :subjects => :environment do
#
#
#	desc "Import data from piis.csv file"
#	task :piis => :environment do
#		puts "Importing piis"
#
#		error_file = File.open('piis_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/piis.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"study_subject_id","childID","subjectID","first_name","middle_name","last_name",
#			#		"dob","died_on","state_id_no","mother_first_name","mother_middle_name",
#			#		"mother_last_name","mother_maiden_name","father_first_name","father_middle_name",
#			#		"father_last_name","email"
#
#			dob     = (line['dob'].blank?) ? Chronic.parse('10 years ago') : Time.parse(line['dob'])
##
##	convert dob back to this format to ensure it is the same
##
#			died_on = (line['died_on'].blank?) ? '' : Time.parse(line['died_on'])
##
##	convert died_on back to this format to ensure it is the same
##
#			attributes = {
#				:study_subject_id   => line['study_subject_id'],
#				:first_name         => line['first_name'],
#				:middle_name        => line['middle_name'],
#				:last_name          => line['last_name'],
#				:dob                => dob,
#				:died_on            => died_on,
#				:mother_first_name  => line['mother_first_name'],
#				:mother_middle_name => line['mother_middle_name'],
#				:mother_last_name   => line['mother_last_name'],
#				:mother_maiden_name => line['mother_maiden_name'],
#				:father_first_name  => line['father_first_name'],
#				:father_middle_name => line['father_middle_name'],
#				:father_last_name   => line['father_last_name']
#			}
#			Pii.create!(attributes)
##			pii = Pii.create(attributes)
##			if pii.new_record?
##				error_file.puts line
##				error_file.puts pii.errors.full_messages.to_sentence
##				error_file.puts
##			end
#			
#		end	#	FasterCSV.open
#
#		error_file.close
#
#	end		#	task :piis => :environment do
#
#	desc "Import data from identifiers.csv file"
#	task :identifiers => :environment do
#		puts "Importing identifiers"
#
#		error_file = File.open('identifiers_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/identifiers.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"study_subject_id","childID","subjectID","childIDWho","PatID","CaCoType",
#			#		"OrderNo","StudyID","newID","GBID","LabNo-CCLS","LabNo-Wiemels","IDNO-Wiemels",
#			#		"AccessionNo","StateIDNo","StudyID-noHyphen","StudyID-IntegerOnly-noHyphen",
#			#		"ICFMasterID","HospitalIDNo"
#
#			attributes = {
#				:study_subject_id  => line['study_subject_id'],
#				:childid           => line['childID'],
#				:subjectid         => line['subjectID'],
#				:patid             => line['PatID'] || f.lineno,			#	TODO
#				:case_control_type => line['CaCoType'] || 'X',				#	TODO
#				:orderno           => line['OrderNo'] || f.lineno,		#	TODO
#				:state_id_no       => sprintf("%s %d",line['StateIDNo'], f.lineno),
#				:hospital_no       => line['HospitalIDNo']
#			}
#			Identifier.create!(attributes)
#
##			identifier = Identifier.create(attributes)
##			if identifier.new_record?
##				error_file.puts line
##				error_file.puts identifier.errors.full_messages.to_sentence
##				error_file.puts
##			end
#			
#		end	#	FasterCSV.open
#
#		error_file.close
#
#	end		#	task :identifiers => :environment do
#
#	desc "Import data from enrollments.csv file"
#	task :enrollments => :environment do
#		puts "Importing enrollments"
#
#		error_file = File.open('enrollments_errors.txt','w')
#
#		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
#		(f=FasterCSV.open("#{BASEDIR}/enrollments.csv", 'rb',{
#			:headers => true })).each do |line|
#			puts "Processing line #{f.lineno}"
#			puts line
#
#			#	"study_subject_id","project_id","recruitment_priority","able_to_locate",
#			#		"is_candidate","is_eligible","ineligible_reason_id","ineligible_reason_specify",
#			#		"consented","consented_on","refusal_reason_id","other_refusal_reason",
#			#		"is_chosen","reason_not_chosen","terminated_participation","terminated_reason",
#			#		"is_complete","completed_on","is_closed","reason_closed","notes","created_at",
#			#		"updated_at","document_version_id","project_outcome_id","project_outcome_on",
#			#		"problem","search_outcome","letter_outcome","FinalHomexEnrollmentsID"
#
#			attributes = {
#				:study_subject_id          => line['study_subject_id'],
#				:project_id                => line['project_id'],
#				:recruitment_priority      => line['recruitment_priority'],
#				:able_to_locate            => line['able_to_locate'],
#				:is_candidate              => line['is_candidate'],
#				:is_eligible               => line['is_eligible'],
#				:ineligible_reason_id      => line['ineligible_reason_id'],
#				:ineligible_reason_specify => line['ineligible_reason_specify'],
#				:consented                 => line['consented'],
#				:consented_on              => line['consented_on'],
#				:refusal_reason_id         => line['refusal_reason_id'],
#				:other_refusal_reason      => line['other_refusal_reason'],
#				:is_chosen                 => line['is_chosen'],
#				:reason_not_chosen         => line['reason_not_chosen'],
#				:terminated_participation  => line['terminated_participation'],
#				:terminated_reason         => line['terminated_reason'],
#				:is_complete               => line['is_complete'],
#				:completed_on              => line['completed_on'],
#				:is_closed                 => line['is_closed'],
#				:reason_closed             => line['reason_closed'],
#				:notes                     => line['notes'],
#				:document_version_id       => line['document_version_id'],
#				:project_outcome_id        => line['project_outcome_id'],
#				:project_outcome_on        => line['project_outcome_on']
#			}
#
##puts attributes.inspect
##	Forcing things
##			if attributes[:is_complete] && attributes[:completed_on].blank?
##				attributes[:completed_on] = Date.today 
##			end
##			if attributes[:consented] && attributes[:consented_on].blank?
##				attributes[:consented_on] = Date.today 
##			end
##			if attributes[:is_eligible] == '2' && attributes[:ineligible_reason_id].blank?
##				attributes[:ineligible_reason_id] = IneligibleReason['moved'].id
##			end
##			if attributes[:consented] == '2' && attributes[:refusal_reason_id].blank?
##				attributes[:refusal_reason_id] = RefusalReason['busy'].id
##			end
##			if attributes[:refusal_reason_id] == '7' && attributes[:other_refusal_reason].blank?
##				attributes[:other_refusal_reason] = "unknown"
##			end
##puts attributes.inspect
##			Enrollment.create!(attributes)
#
#			enrollment = Enrollment.create(attributes)
#			if enrollment.new_record?
#				error_file.puts line
#				error_file.puts enrollment.errors.full_messages.to_sentence
#				error_file.puts
#			end
#			
#		end	#	FasterCSV.open
#
#		error_file.close
#
#	end		#	task :enrollments => :environment do

end
