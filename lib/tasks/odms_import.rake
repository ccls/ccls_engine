require 'fastercsv'
require 'chronic'

#BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/Database/DataLists/jake/"
#BASEDIR = "/Volumes/BUF-Fileshare/RestrictedData/StaffFolders/WendtJake/HomeExposuresImport_20110504/"
#BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/Database/DataLists/HomeExposuresImport_20110504/"
BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/DataMigration/"

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
#		BcRequest.destroy_all
#		CandidateControl.destroy_all
	end

end


namespace :odms_import do

	task :csv_dump => :environment do
		puts "Dumping to csv for comparison"

		FasterCSV.open('subject_out.csv','w') do |f|
			f.add_row "subjectID,subjectType_id,vital_status_id,do_not_contact,sex,refdate,ChildId,icf_master_id,matchingID,familyID,PatID,case_control_type,OrderNo,newID,studyID,related_case_childID,state_id_no,subject_type_id,admit_date,diagnosis_id,organization_id,ODMS_Patients_092611.created_at,was_previously_treated,was_under_15_at_dx,Zipcode,County,first_name,middle_name,last_name,maiden_name,dob,died_on,mother_first_name,mother_maiden_name,mother_last_name,father_first_name,father_last_name,ODMS_Identifiers_092611.created_at".split(',')

			StudySubject.find(:all, :limit => 9).each do |s|
				was_previously_treated = ( s.patient.try(:was_previously_treated).blank? ) ?
					nil : YNDK[s.patient.was_previously_treated.to_s.to_sym]
				was_under_15_at_dx = ( s.patient.try(:was_under_15_at_dx).blank? ) ?
					nil : YNDK[s.patient.was_under_15_at_dx.to_s.to_sym]
				f.add_row([
					s.identifier.subjectid,
#	NOTE will cause issues as not all input data subject_type_id matched subjectType_id
					s.subject_type_id,
					s.vital_status_id,
					s.do_not_contact.to_s.upcase,
					s.sex,
					s.reference_date.try(:strftime,"%d-%b-%y"),
					s.identifier.childid,
					s.identifier.icf_master_id,
					s.identifier.matchingid,
					s.identifier.familyid,
					s.identifier.patid,
					s.identifier.case_control_type,
					s.identifier.orderno,
					s.identifier.newid,

#	NOTE need to explicitly get the studyid attribute (not method)
					s.identifier.read_attribute(:studyid),		

					s.identifier.related_case_childid,
					s.identifier.state_id_no,
					s.subject_type_id,
					s.patient.try(:admit_date).try(:strftime,"%d-%b-%y"),
					s.patient.try(:diagnosis_id),
					s.patient.try(:organization_id),
#	NOTE will cause issues as not all input data included this
					s.patient.try(:created_at).try(:strftime,"%d-%b-%y"),

#	NOTE will cause issues due to data type difference
					was_previously_treated,
					was_under_15_at_dx,

					s.patient.try(:raf_zip),
					s.patient.try(:raf_county),
					s.pii.first_name,
					s.pii.middle_name,
					s.pii.last_name,
					s.pii.maiden_name,
					s.pii.dob.try(:strftime,"%d-%b-%y"),
					s.pii.died_on.try(:strftime,"%d-%b-%y"),
					s.pii.mother_first_name,
					s.pii.mother_maiden_name,
					s.pii.mother_last_name,
					s.pii.father_first_name,
					s.pii.father_last_name,
#	NOTE will cause issues as not all input data included this
					s.identifier.created_at.try(:strftime,"%d-%b-%y")
				])
			end

		end
	end

	desc "Import subject data from CSV files"
	task :csv_data => [
		'odms_destroy:csv_data',
		'odms_import:subjects',
		'odms_import:icf_master_ids',
		'odms_import:create_dummy_candidate_controls'
	]

	task :icf_master_ids => :environment do 
		puts "Destroying icf_master_ids"
		IcfMasterId.destroy_all
		puts "Importing icf_master_ids"

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("#{BASEDIR}/export_ODMS_ICF_Master_IDs.csv", 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			attributes = {
				:icf_master_id => line['icf_master_id']
			}

			if line['subjectid'] and !line['subjectid'].blank?
				identifiers = Identifier.find(:all,
					:conditions => { :subjectid => line['subjectid'] } )
				case 
					when identifiers.length > 1
						raise "More than one identifier found matching subjectid:#{line['subjectid']}:"
					when identifiers.length == 0
						raise "No identifier found matching subjectid:#{line['subjectid']}:"
					else
						puts "Found identifier matching subjectid:#{line['subjectid']}:"
				end
				attributes[:study_subject_id] = identifiers.first.study_subject_id
				attributes[:assigned_on] = Time.parse(line['assigned_on'])
			else
				#	I just noticed that some of the icf_master_ids are actually
				#	assigned in the subject data, but not marked as being
				#	assigned in the icf_master_id list.  So, search for them.
				identifiers = Identifier.find(:all,
					:conditions => { :icf_master_id => line['icf_master_id'] } )
				case 
					when identifiers.length > 1
						raise "More than one identifier found matching icf_master_id:#{line['icf_master_id']}:"
#					when identifiers.length == 0
#						raise "No identifier found matching icf_master_id:#{line['icf_master_id']}:"
					when identifiers.length == 1
						puts "Found identifier matching icf_master_id:#{line['icf_master_id']}:"
						attributes[:study_subject_id] = identifiers.first.study_subject_id
						attributes[:assigned_on] = Date.today
				end
			end

			IcfMasterId.create!(attributes)
		end

	end


	task :create_dummy_candidate_controls => :environment do
		puts "Destroying candidate controls"
		CandidateControl.destroy_all
		puts "Importing candidate controls"
#Factory.define :candidate_control do |f|
#	f.first_name "First"
#	f.last_name  "Last"
#	f.dob Date.jd(2440000+rand(15000))
#	f.reject_candidate false
#end

		SubjectType['Case'].study_subjects.each do |s|
			rand(5).times do |i|
				puts "Creating candidate control for study_subject_id:#{s.id}"
				CandidateControl.create!({
					:related_patid => s.patid,
					:first_name => "First#{i}",
					:last_name  => "Last#{s.id}",
					:sex        => ['M','F'][rand(2)],
					:dob        => Date.jd(2440000+rand(15000))
				})
			end
		end
		
		printf "%-19s %5d\n", "CandidateControl.count:", CandidateControl.count
	end

	desc "Import data from subjects.csv file"
	task :subjects => :environment do
		puts "Importing subjects"

		error_file = File.open('subjects_errors.txt','w')

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("#{BASEDIR}/ODMS_SubjectData_Combined_092611.csv", 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#	subjectID,subjectType_id,vital_status_id,do_not_contact,sex,refdate
#,ChildId,icf_master_id,matchingID,familyID,PatID,case_control_type,OrderNo,newID,studyID,related_case_childID,state_id_no,
#subject_type_id
#,admit_date,diagnosis_id,organization_id,
#ODMS_Patients_092611.created_at,was_previously_treated,was_under_15_at_dx,Zipcode,County
#,first_name,middle_name,last_name,maiden_name,dob,died_on,mother_first_name,mother_maiden_name,mother_last_name,father_first_name,father_last_name,ODMS_Identifiers_092611.created_at

#	BEGIN anticipated errors

			if line['subject_type_id'].blank?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: No subject_type_id"
				error_file.puts line
			end

			if line['subject_type_id'] != line['subjectType_id']
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subject type id mismatch: " <<
					"subject_type_id:#{line['subject_type_id']}: " <<
					"subjectType_id:#{line['subjectType_id']}:"
				error_file.puts line
			end

			if line['first_name'].blank?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: No first_name"
				error_file.puts line
			end

			if line['last_name'].blank?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: No last_name"
				error_file.puts line
			end

			raf_zip = line['Zipcode']
			if !raf_zip.blank? and ![5,10].include?(raf_zip.length)
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: Unexpected zipcode length :#{raf_zip}:"
				error_file.puts line
				raf_zip = '99999'
			end

			state_id_no = line['state_id_no']
			if !state_id_no.blank? && Identifier.exists?(:state_id_no => state_id_no)
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: " <<
					"state_id_no is a duplicate:#{line['state_id_no']}:"
				error_file.puts line
				state_id_no = nil
			end

#	END anticipated errors

			pii = Pii.new do |m|
				m.first_name         = line['first_name'] || "FIXME"	#	TODO
				m.middle_name        = line['middle_name']
				m.last_name          = line['last_name'] || "FIXME"	#	TODO
				m.maiden_name        = line['maiden_name']
				m.died_on            = ( line['died_on'].blank? 
					) ? nil : Time.parse(line['died_on'])
				m.mother_first_name  = line['mother_first_name']
				m.mother_maiden_name = line['mother_maiden_name']
				m.mother_last_name   = line['mother_last_name']
				m.father_first_name  = line['father_first_name']
				m.father_last_name   = line['father_last_name']

				if line['subject_type_id'].to_i == SubjectType['Mother'].id
					m.subject_is_mother = true
					m.dob               = ( line['dob'].blank? 
						) ? nil : Time.parse(line['dob']).to_date
				else
					#	blank dob only a problem if not mother
					if line['dob'].blank?
						error_file.puts 
						error_file.puts "Line #:#{f.lineno}: No dob and not mother"
						error_file.puts line
					end
					m.dob               = (( line['dob'].blank? 
						) ? Time.parse('01-Jan-1900') : Time.parse(line['dob']) ).to_date
				end
			end

			identifier = Identifier.new do |m|
				m.subjectid     = line['subjectID']
				m.childid       = line['ChildId']
				m.icf_master_id = line['icf_master_id']
				m.matchingid    = line['matchingID']
				m.familyid      = line['familyID']
				m.patid         = line['PatID']
				m.orderno       = line['OrderNo']
				m.newid         = line['newID']
				m.studyid       = line['studyID']
				m.state_id_no   = state_id_no
				m.case_control_type = line['case_control_type']
				m.related_case_childid = line['related_case_childID']
				m.created_at         = line['ODMS_Identifiers_092611.created_at']
			end

			attributes = {
				:subject_type_id => line['subject_type_id'],
				:vital_status_id => line['vital_status_id'],
				:do_not_contact  => line['do_not_contact'],
				:sex             => line['sex'],
				:reference_date  => ( line['refdate'].blank?
						) ? nil : Time.parse(line['refdate']),
				:pii             => pii,
				:identifier      => identifier
			}

			if line['subject_type_id'] == '1'
				patient = Patient.new do |m|
					m.admit_date = ( line['admit_date'].blank?
						) ? nil : Time.parse(line['admit_date'])
					m.diagnosis_id    = line['diagnosis_id']
					m.organization_id = line['organization_id']
					m.was_previously_treated = line['was_previously_treated']
					m.was_under_15_at_dx     = line['was_under_15_at_dx']
					m.raf_zip                = raf_zip
					m.raf_county             = line['County']
					m.created_at             = line['ODMS_Patients_092611.created_at']
				end
				attributes[:patient] = patient
			end

			s = StudySubject.create!(attributes)
		end	#	FasterCSV.open
		error_file.close

		printf "%-19s %5d\n", "StudySubject.count:", StudySubject.count
		printf "%-19s %5d\n", "Identifier.count:", Identifier.count
		printf "%-19s %5d\n", "Pii.count:", Pii.count
		printf "%-19s %5d\n", "Patient.count:", Patient.count
	end		#	task :subjects => :environment do

end
