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
#		ResponseSet.destroy_all
#		Response.destroy_all
		Sample.destroy_all
		SampleKit.destroy_all
		Package.destroy_all
		HomexOutcome.destroy_all
		HomeExposureResponse.destroy_all
#		SurveyInvitation.destroy_all
	end

end


namespace :import do

	desc "Import subject and address data from CSV files"
	task :csv_data => [
		'destroy:csv_data',
#		'import:identifiers'
#		'import:piis'
#		'import:subjects'
#		'import:enrollments'
		'import:contacts'
	]

	desc "Import data from contacts.csv file"
	task :contacts => :environment do
		puts "Importing subjects"
		require 'fastercsv'

		error_file = File.open('contacts_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/contacts.csv', 'rb',{
			:headers => true })).each do |line|

#"ID","Review","ReviewNotes","DataSource","AddressType","ChildID","Street","City","State","Zipcode","FIPSCountyCode","County","Original","Interview","IsCurrent","StartDate","EndDate","EntryDate","T2KAddressID","childID-deleteme","study_subject_id","t2k_primary_phone","t2k_alt_phone","src_primary_phone","src_alt_phone_1","src_alt_phone_2","src_alt_phone_3"
#3,FALSE,,"tAddresses (T2K)","Residence",393,"1247 Green Acres Ct","Santa Cruz","CA","95062","087","Santa Cruz",TRUE,FALSE,TRUE,,,20-Nov-00,415,,1867,"(831) 476-7564",,"(831) 336-9389",,,

			puts "Processing line #{f.lineno}"
			puts line


		end	#	FasterCSV.open
		error_file.close
	end		#	task :contacts => :environment do


	desc "Import data from piis.csv file"
	desc "Import data from subjects.csv file"
	task :subjects => :environment do
		puts "Importing subjects"
		require 'fastercsv'

		error_file = File.open('subjects_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/subjects.csv', 'rb',{
			:headers => true })).each do |line|

#"study_subject_id","newID","subjectID","childID","Who","subjectType","relatedPatID","matchingID","familyID","relatedChildID","T2K_subjectsTableID"
			puts "Processing line #{f.lineno}"
			puts line

#	 0 - study_subject_id OR id ?
#	 1 - newID ???
#	 2 - identifiers.subjectid
#	 3 - identifiers.childid
#	 4 - Who ???
#	 5 - subject_type.code	NO ?? identifiers.case_control_type
#	 6 - relatedPatID  ???
#	 7 - identifiers.matchingid
#	 8 - identifiers.familyid
#	 9 - identifiers.related_childid
#	10 - T2K_subjectsTableID ???

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
#"study_subject_id","childID","subjectID","first_name","middle_name","last_name","dob","died_on","state_id_no","mother_first_name","mother_middle_name","mother_last_name","mother_maiden_name","father_first_name","father_middle_name","father_last_name","email"
			puts "Processing line #{f.lineno}"
			puts line

#	 0 - study_subject_id
#	 1 - identifiers.childid
#	 2 - identifiers.subjectid
#	 3 - first_name
#	 4 - middle_name
#	 5 - last_name
#	 6 - dob
#	 7 - died_on
#	 8 - identifiers.state_id_no
#	 9 - mother_first_name
#	10 - mother_middle_name
#	11 - mother_last_name
#	12 - mother_maiden_name
#	13 - father_first_name
#	14 - father_middle_name
#	15 - father_last_name
#	16 - email

			dob     = (line[6].blank?) ? Chronic.parse('10 years ago') : Time.parse(line[6])
#
#	convert dob back to this format to ensure it is the same
#
			died_on = (line[7].blank?) ? '' : Time.parse(line[7])
#
#	convert died_on back to this format to ensure it is the same
#
			attributes = {
				:study_subject_id   => line[0],
				:first_name         => line[3],
				:middle_name        => line[4],
				:last_name          => line[5],
				:dob                => dob,
				:died_on            => died_on,
				:mother_first_name  => line[9],
				:mother_middle_name => line[10],
				:mother_last_name   => line[11],
				:mother_maiden_name => line[12],
				:father_first_name  => line[13],
				:father_middle_name => line[14],
				:father_last_name   => line[15]
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
		require 'fastercsv'

		error_file = File.open('identifiers_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/identifiers.csv', 'rb',{
			:headers => true })).each do |line|
#"study_subject_id","childID","subjectID","childIDWho","PatID","CaCoType","OrderNo","StudyID","newID","GBID","LabNo-CCLS","LabNo-Wiemels","IDNO-Wiemels","AccessionNo","StateIDNo","StudyID-noHyphen","StudyID-IntegerOnly-noHyphen","ICFMasterID","HospitalIDNo"
			puts "Processing line #{f.lineno}"
			puts line

#  0 - study_subject_id
#	 1 - childid
#	 2 - subjectid
#	 3 - childIDWho	???
#	 4 - patid
#	 5 - case_control_type (1 char)
#	 6 - orderno
#	 7 - StudyID 		"#{patid}-#{case_control_type}-#{orderno}"
#	 8 - newID ??
#	 9 - GBID ??
#	10 - LabNo-CCLS ??
#	11 - LabNo-Wiemels ??
#	12 - IDNO-Wiemels ??
#	13 - AccessionNo ??
#	14 - state_id_no
#	15 - StudyID-noHyphen ??
#	16 - StudyID-IntegerOnly-noHyphen ??
#	17 - ICFMasterID ??
#	18 - HospitalIDNo ??  hospital_no


			attributes = {
				:ssn => sprintf("%09d",f.lineno),									#	forcing
				:study_subject_id  => line[0],
				:childid           => line[1],
				:subjectid         => line[2],	# || sprintf("9%05d", f.lineno),
				:patid             => line[4],	# || f.lineno,
				:case_control_type => line[5],	# || 'X',
				:orderno           => line[6],	# || f.lineno,
				:state_id_no       => sprintf("%s %d",line[14], f.lineno),
				:hospital_no       => line[18]
			}
			identifier = Identifier.create(attributes)

			if identifier.new_record?
				error_file.puts line
				error_file.puts identifier.errors.full_messages.to_sentence
				error_file.puts
			end
			
		end	#	FasterCSV.open

		error_file.close

	end		#	task :identifiers => :environment do

	desc "Import data from enrollments.csv file"
	task :enrollments => :environment do
		puts "Importing enrollments"
		require 'fastercsv'

		error_file = File.open('enrollments_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open('misc/enrollments.csv', 'rb',{
			:headers => true })).each do |line|

#"study_subject_id","project_id","recruitment_priority","able_to_locate","is_candidate","is_eligible","ineligible_reason_id","ineligible_reason_specify","consented","consented_on","refusal_reason_id","other_refusal_reason","is_chosen","reason_not_chosen","terminated_participation","terminated_reason","is_complete","completed_on","is_closed","reason_closed","notes","created_at","updated_at","document_version_id","project_outcome_id","project_outcome_on","problem","search_outcome","letter_outcome","FinalHomexEnrollmentsID"

			puts "Processing line #{f.lineno}"
			puts line

#	 0 - study_subject_id
#	 1 - project_id
#	 2 - recruitment_priority
#	 3 - able_to_locate
#	 4 - is_candidate
#	 5 - is_eligible
#	 6 - ineligible_reason_id
#	 7 - ineligible_reason_specify
#	 8 - consented
#	 9 - consented_on
#	10 - refusal_reason_id
#	11 - other_refusal_reason
#	12 - is_chosen
#	13 - reason_not_chosen
#	14 - terminated_participation
#	15 - terminated_reason
#	16 - is_complete
#	17 - completed_on
#	18 - is_closed
#	19 - reason_closed
#	20 - notes
#	21 - created_at
#	22 - updated_at
#	23 - document_version_id
#	24 - project_outcome_id
#	25 - project_outcome_on
#	26 - problem
#	27 - search_outcome
#	28 - letter_outcome
#	29 - FinalHomexEnrollmentsID

			attributes = {
				:study_subject_id          => line[0],
				:project_id                => line[1],
				:recruitment_priority      => line[2],
				:able_to_locate            => line[3],
				:is_candidate              => line[4],
				:is_eligible               => line[5],
				:ineligible_reason_id      => line[6],
				:ineligible_reason_specify => line[7],
				:consented                 => line[8],
				:consented_on              => line[9],
				:refusal_reason_id         => line[10],
				:other_refusal_reason      => line[11],
				:is_chosen                 => line[12],
				:reason_not_chosen         => line[13],
				:terminated_participation  => line[14],
				:terminated_reason         => line[15],
				:is_complete               => line[16],
				:completed_on              => line[17],
				:is_closed                 => line[18],
				:reason_closed             => line[19],
				:notes                     => line[20],
#	21 - created_at
#	22 - updated_at
				:document_version_id       => line[23],
				:project_outcome_id        => line[24],
				:project_outcome_on        => line[25]
#	26 - problem
#	27 - search_outcome
#	28 - letter_outcome
#	29 - FinalHomexEnrollmentsID
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
