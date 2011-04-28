require 'fastercsv'
require 'chronic'
namespace :destroy do

	desc "Destroy subject and address data"
	task :csv_data => :environment do
		puts "Destroying existing data"
		Subject.destroy_all
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


namespace :import do

	desc "Import subject and address data from CSV files"
	task :csv_data => [
		'destroy:csv_data',
		'import:subjects',
#		'import:identifiers'
#		'import:piis',
#		'import:enrollments',
#		'import:contacts'
	]

	desc "Import data from contacts.csv file"
	task :contacts => :environment do
		puts "Importing contacts"

		error_file = File.open('contacts_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/contacts.csv', 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			#	"ID","Review","ReviewNotes","DataSource","AddressType","ChildID","Street","City",
			#		"State","Zipcode","FIPSCountyCode","County","Original","Interview","IsCurrent",
			#		"StartDate","EndDate","EntryDate","T2KAddressID","childID-deleteme",
			#		"study_subject_id","t2k_primary_phone","t2k_alt_phone","src_primary_phone",
			#		"src_alt_phone_1","src_alt_phone_2","src_alt_phone_3"


		end	#	FasterCSV.open
		error_file.close
	end		#	task :contacts => :environment do


	desc "Import data from subjects.csv file"
	task :subjects => :environment do
		puts "Importing subjects"

		error_file = File.open('subjects_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/subjects.csv', 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			#	"study_subject_id","newID","subjectID","childID","Who","subjectType","relatedPatID",
			#		"matchingID","familyID","relatedChildID","T2K_subjectsTableID"

			attributes = {
				:identifier_attributes => {
					:childid           => line['childID'],
					:subjectid         => line['subjectID'],
					:matchingid        => line['matchingID'],
					:familyid          => line['familyID'],
					:case_control_type => line['subjectType'],
					:related_childid   => line['relatedChildID']
				}
			}
			Subject.create!(attributes)


		end	#	FasterCSV.open
		error_file.close
	end		#	task :subjects => :environment do


	desc "Import data from piis.csv file"
	task :piis => :environment do
		puts "Importing piis"

		error_file = File.open('piis_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/piis.csv', 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			#	"study_subject_id","childID","subjectID","first_name","middle_name","last_name",
			#		"dob","died_on","state_id_no","mother_first_name","mother_middle_name",
			#		"mother_last_name","mother_maiden_name","father_first_name","father_middle_name",
			#		"father_last_name","email"

			dob     = (line['dob'].blank?) ? Chronic.parse('10 years ago') : Time.parse(line['dob'])
#
#	convert dob back to this format to ensure it is the same
#
			died_on = (line['died_on'].blank?) ? '' : Time.parse(line['died_on'])
#
#	convert died_on back to this format to ensure it is the same
#
			attributes = {
				:study_subject_id   => line['study_subject_id'],
				:first_name         => line['first_name'],
				:middle_name        => line['middle_name'],
				:last_name          => line['last_name'],
				:dob                => dob,
				:died_on            => died_on,
				:mother_first_name  => line['mother_first_name'],
				:mother_middle_name => line['mother_middle_name'],
				:mother_last_name   => line['mother_last_name'],
				:mother_maiden_name => line['mother_maiden_name'],
				:father_first_name  => line['father_first_name'],
				:father_middle_name => line['father_middle_name'],
				:father_last_name   => line['father_last_name']
			}
			Pii.create!(attributes)
#			pii = Pii.create(attributes)
#			if pii.new_record?
#				error_file.puts line
#				error_file.puts pii.errors.full_messages.to_sentence
#				error_file.puts
#			end
			
		end	#	FasterCSV.open

		error_file.close

	end		#	task :piis => :environment do

	desc "Import data from identifiers.csv file"
	task :identifiers => :environment do
		puts "Importing identifiers"

		error_file = File.open('identifiers_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/identifiers.csv', 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			#	"study_subject_id","childID","subjectID","childIDWho","PatID","CaCoType",
			#		"OrderNo","StudyID","newID","GBID","LabNo-CCLS","LabNo-Wiemels","IDNO-Wiemels",
			#		"AccessionNo","StateIDNo","StudyID-noHyphen","StudyID-IntegerOnly-noHyphen",
			#		"ICFMasterID","HospitalIDNo"

			attributes = {
				:study_subject_id  => line['study_subject_id'],
				:childid           => line['childID'],
				:subjectid         => line['subjectID'],
				:patid             => line['PatID'] || f.lineno,			#	TODO
				:case_control_type => line['CaCoType'] || 'X',				#	TODO
				:orderno           => line['OrderNo'] || f.lineno,		#	TODO
				:state_id_no       => sprintf("%s %d",line['StateIDNo'], f.lineno),
				:hospital_no       => line['HospitalIDNo']
			}
			Identifier.create!(attributes)

#			identifier = Identifier.create(attributes)
#			if identifier.new_record?
#				error_file.puts line
#				error_file.puts identifier.errors.full_messages.to_sentence
#				error_file.puts
#			end
			
		end	#	FasterCSV.open

		error_file.close

	end		#	task :identifiers => :environment do

	desc "Import data from enrollments.csv file"
	task :enrollments => :environment do
		puts "Importing enrollments"

		error_file = File.open('enrollments_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/enrollments.csv', 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			#	"study_subject_id","project_id","recruitment_priority","able_to_locate",
			#		"is_candidate","is_eligible","ineligible_reason_id","ineligible_reason_specify",
			#		"consented","consented_on","refusal_reason_id","other_refusal_reason",
			#		"is_chosen","reason_not_chosen","terminated_participation","terminated_reason",
			#		"is_complete","completed_on","is_closed","reason_closed","notes","created_at",
			#		"updated_at","document_version_id","project_outcome_id","project_outcome_on",
			#		"problem","search_outcome","letter_outcome","FinalHomexEnrollmentsID"

			attributes = {
				:study_subject_id          => line['study_subject_id'],
				:project_id                => line['project_id'],
				:recruitment_priority      => line['recruitment_priority'],
				:able_to_locate            => line['able_to_locate'],
				:is_candidate              => line['is_candidate'],
				:is_eligible               => line['is_eligible'],
				:ineligible_reason_id      => line['ineligible_reason_id'],
				:ineligible_reason_specify => line['ineligible_reason_specify'],
				:consented                 => line['consented'],
				:consented_on              => line['consented_on'],
				:refusal_reason_id         => line['refusal_reason_id'],
				:other_refusal_reason      => line['other_refusal_reason'],
				:is_chosen                 => line['is_chosen'],
				:reason_not_chosen         => line['reason_not_chosen'],
				:terminated_participation  => line['terminated_participation'],
				:terminated_reason         => line['terminated_reason'],
				:is_complete               => line['is_complete'],
				:completed_on              => line['completed_on'],
				:is_closed                 => line['is_closed'],
				:reason_closed             => line['reason_closed'],
				:notes                     => line['notes'],
				:document_version_id       => line['document_version_id'],
				:project_outcome_id        => line['project_outcome_id'],
				:project_outcome_on        => line['project_outcome_on']
			}

#puts attributes.inspect
#	Forcing things
#			if attributes[:is_complete] && attributes[:completed_on].blank?
#				attributes[:completed_on] = Date.today 
#			end
#			if attributes[:consented] && attributes[:consented_on].blank?
#				attributes[:consented_on] = Date.today 
#			end
#			if attributes[:is_eligible] == '2' && attributes[:ineligible_reason_id].blank?
#				attributes[:ineligible_reason_id] = IneligibleReason['moved'].id
#			end
#			if attributes[:consented] == '2' && attributes[:refusal_reason_id].blank?
#				attributes[:refusal_reason_id] = RefusalReason['busy'].id
#			end
#			if attributes[:refusal_reason_id] == '7' && attributes[:other_refusal_reason].blank?
#				attributes[:other_refusal_reason] = "unknown"
#			end
#puts attributes.inspect
#			Enrollment.create!(attributes)

			enrollment = Enrollment.create(attributes)
			if enrollment.new_record?
				error_file.puts line
				error_file.puts enrollment.errors.full_messages.to_sentence
				error_file.puts
			end
			
		end	#	FasterCSV.open

		error_file.close

	end		#	task :enrollments => :environment do

end
