require 'fastercsv'
require 'chronic'

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
		OperationalEvent.destroy_all
		#	have to destroy these as well as they are associated with a given 
		#	subject, all of which were just destroyed.
		BcRequest.destroy_all	
		CandidateControl.destroy_all
		IcfMasterId.destroy_all
	end

end


namespace :odms_import do

	task :prepare_input_for_comparison do
		FasterCSV.open('subject_in.csv','w', {:force_quotes=>true}) do |out|
			out.add_row ["subjectid","subject_type_id","vital_status_id","do_not_contact","sex","reference_date","childidwho","hispanicity_id","childid","icf_master_id","matchingid","familyid","patid","case_control_type","orderno","newid","studyid","related_case_childid","state_id_no","admit_date","diagnosis_id","created_at","first_name","middle_name","last_name","maiden_name","dob","died_on","mother_first_name","mother_maiden_name","mother_last_name","father_first_name","father_last_name","was_previously_treated","was_under_15_at_dx","raf_zip","raf_county","birth_year","hospital_no","organization_id","other_diagnosis"]
	
#
#
#	GONNA NEED TO SORT THESE TO COMPARE THEM, BUT BEWARE! OF MULTI-LINED ENTRIES
#
#
			#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
			(f=FasterCSV.open("#{BASEDIR}/ODMS_SubjectData_Combined_xxxxxx.csv", 'rb',{
				:headers => true })).each do |line|
#break if f.lineno > 10

#	
#	Some columns are quoted and some aren't.
#		quote all
#	Some dates are dates and some are strings so the format is different.
#	Some have created_at, some don't
#

#	TEMPORARY
				line['was_previously_treated'] = nil
				line['was_under_15_at_dx'] = nil


				line['created_at'] = nil
				line['reference_date'] = if line['reference_date'].blank?
					nil
				else
					Time.parse(line['reference_date']).to_date.try(:strftime,"%m/%d/%Y")
				end
				line['admit_date'] = if line['admit_date'].blank?
					nil
				else
					Time.parse(line['admit_date']).to_date.try(:strftime,"%m/%d/%Y")
				end
				line['dob'] = if line['dob'].blank?
					nil
				else
					Time.parse(line['dob']).to_date.try(:strftime,"%m/%d/%Y")
				end
				line['died_on'] = if line['died_on'].blank?
					nil
				else
					Time.parse(line['died_on']).to_date.try(:strftime,"%m/%d/%Y")
				end
				out.add_row line
			end

		end
	end

	task :csv_dump => :environment do
		puts "Dumping to csv for comparison"

		FasterCSV.open('subject_out.csv','w', {:force_quotes=>true}) do |f|
#		FasterCSV.open('subject_out.csv','w') do |f|
#			f.add_row "subjectID,subjectType_id,vital_status_id,do_not_contact,sex,refdate,ChildId,icf_master_id,matchingID,familyID,PatID,case_control_type,OrderNo,newID,studyID,related_case_childID,state_id_no,subject_type_id,admit_date,diagnosis_id,organization_id,ODMS_Patients_092611.created_at,was_previously_treated,was_under_15_at_dx,Zipcode,County,first_name,middle_name,last_name,maiden_name,dob,died_on,mother_first_name,mother_maiden_name,mother_last_name,father_first_name,father_last_name,ODMS_Identifiers_092611.created_at".split(',')
			f.add_row ["subjectid","subject_type_id","vital_status_id","do_not_contact","sex","reference_date","childidwho","hispanicity_id","childid","icf_master_id","matchingid","familyid","patid","case_control_type","orderno","newid","studyid","related_case_childid","state_id_no","admit_date","diagnosis_id","created_at","first_name","middle_name","last_name","maiden_name","dob","died_on","mother_first_name","mother_maiden_name","mother_last_name","father_first_name","father_last_name","was_previously_treated","was_under_15_at_dx","raf_zip","raf_county","birth_year","hospital_no","organization_id","other_diagnosis"]

#			StudySubject.find(:all, :limit => 9).each do |s|
#
#
#	GONNA NEED TO SORT THESE TO COMPARE THEM
#
#
			StudySubject.find(:all,
					:include => :identifier, 
					:order => 'identifiers.subjectid ASC' ).each do |s|
				was_previously_treated = ( s.patient.try(:was_previously_treated).blank? ) ?
					nil : YNDK[s.patient.was_previously_treated.to_s.to_sym]
				was_under_15_at_dx = ( s.patient.try(:was_under_15_at_dx).blank? ) ?
					nil : YNDK[s.patient.was_under_15_at_dx.to_s.to_sym]
				f.add_row([
					s.identifier.subjectid,
					s.subject_type_id,
					s.vital_status_id,
					s.do_not_contact.to_s.upcase,	# FALSE
#					s.do_not_contact,	#false
#					(( s.do_not_contact ) ? 1 : 0 ),
					s.sex,
#					s.reference_date.try(:strftime,"%d-%b-%y"),
					s.reference_date.try(:strftime,"%m/%d/%Y"),
					s.identifier.childidwho,
					s.hispanicity_id,
					s.identifier.childid,
					s.identifier.icf_master_id,
					s.identifier.matchingid,
					s.identifier.familyid,
					s.identifier.patid,
					s.identifier.case_control_type,
					s.identifier.orderno,
					s.identifier.newid,
					s.identifier.studyid,		
					s.identifier.related_case_childid,
					s.identifier.state_id_no,
#					s.patient.try(:admit_date).try(:strftime,"%d-%b-%y"),
					s.patient.try(:admit_date).try(:strftime,"%m/%d/%Y"),
					s.patient.try(:diagnosis_id),
#					s.try(:created_at).try(:strftime,"%d-%b-%y"),
#					s.try(:created_at).try(:strftime,"%m/%d/%Y"),
					nil,
					s.pii.first_name,
					s.pii.middle_name,
					s.pii.last_name,
					s.pii.maiden_name,
#					s.pii.dob.try(:strftime,"%d-%b-%y"),
					s.pii.dob.try(:strftime,"%m/%d/%Y"),
#					s.pii.died_on.try(:strftime,"%d-%b-%y"),
					s.pii.died_on.try(:strftime,"%m/%d/%Y"),
					s.pii.mother_first_name,
					s.pii.mother_maiden_name,
					s.pii.mother_last_name,
					s.pii.father_first_name,
					s.pii.father_last_name,

#	NOTE will cause issues due to data type difference
#				line['was_previously_treated'] = nil
#				line['was_under_15_at_dx'] = nil
#					was_previously_treated,
#					was_under_15_at_dx,
					nil,
					nil,

					s.patient.try(:raf_zip),
					s.patient.try(:raf_county),
					s.pii.birth_year,
					s.patient.try(:hospital_no),
					s.patient.try(:organization_id),
					s.patient.try(:other_diagnosis)
				])
			end

		end
	end

	desc "Import subject data from CSV files"
	task :csv_data => [
		'odms_destroy:csv_data',
		'odms_import:subjects',
		'odms_import:icf_master_ids',
		'odms_import:enrollments',
		'odms_import:operational_events',
		'odms_import:create_dummy_candidate_controls',
		'ccls:data_report'
	]


	task :operational_events => :environment do 
#	Can't destroy them as there will be some already
#	Actually, this seems to include the subject creation event
#		so destruction may be just fine.
#		puts "Destroying operational_events"
#		OperationalEvent.destroy_all
		puts "Importing operational_events"

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("#{BASEDIR}/ODMS_Operational_Events_xxxxxx.csv", 'rb',{
			:headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#"subjectID","project_id","operational_event_id","occurred_on","description","enrollment_id","event_notes"

			identifier = Identifier.find_by_subjectid(line['subjectID'])	#	misnamed field
			study_subject = identifier.study_subject
			ccls_enrollment = study_subject.enrollments.find_by_project_id(line['project_id'])
			operational_event = OperationalEvent.create!({
				:enrollment_id => ccls_enrollment.id,
				:operational_event_type_id => line['operational_event_id'],
				:occurred_on => Time.parse(line['occurred_on']),
				:description => line['description'],
				:event_notes => line['event_notes']
			})
		end
	end

	task :icf_master_ids => :environment do 
#		puts "Destroying icf_master_ids"
#		IcfMasterId.destroy_all
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
#		puts "Destroying candidate controls"
#		CandidateControl.destroy_all
		puts "Creating dummy candidate controls"
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

	desc "Import data from enrollments.csv file"
	task :enrollments => :environment do
		puts "Importing enrollments"

#		error_file = File.open('enrollments_errors.txt','a')	#	append existing
		error_file = File.open('enrollments_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("#{BASEDIR}/ODMS_Enrollments_xxxxxx.csv", 'rb',{
			:headers => true })).each do |line|

#	skip until ...
#			next if f.lineno <= 10619

			puts "Processing line #{f.lineno}"
			puts line

#"ChildId","project_id","subjectID","consented","consented_on","refusal_reason_id","document_version_id","is_eligible"

			identifier = Identifier.find_by_subjectid(line['subjectID'])	#	misnamed field
			unless identifier
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid #{line['subjectID']} found."
				error_file.puts line
				error_file.puts
				next
			end
			study_subject = identifier.study_subject

			enrollment = study_subject.enrollments.find_or_create_by_project_id(
				line['project_id'])

			saved = enrollment.update_attributes(
				:consented           => line['consented'],
				:consented_on        => (( line['consented'].blank? ) ?
														nil : Time.parse(line['consented']).to_date ),
				:refusal_reason_id   => line['refusal_reason_id'],
				:document_version_id => line['document_version_id'],
				:is_eligible         => line['is_eligible']
			)
			unless saved
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{enrollment.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			end

		end
	end


	desc "Import data from subjects.csv file"
	task :subjects => :environment do
		puts "Importing subjects"

#		error_file = File.open('subjects_errors.txt','a')	#	append existing
		error_file = File.open('subjects_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open("#{BASEDIR}/ODMS_SubjectData_Combined_xxxxxx.csv", 'rb',{
			:headers => true })).each do |line|

#	skip until ...
#			next if f.lineno <= 10619

			puts "Processing line #{f.lineno}"
			puts line

#"subjectid","subject_type_id","vital_status_id","do_not_contact","sex","reference_date","childidwho","hispanicity_id","childid","icf_master_id","matchingid","familyid","patid","case_control_type","orderno","newid","studyid","related_case_childid","state_id_no","admit_date","diagnosis_id","created_at","first_name","middle_name","last_name","maiden_name","dob","died_on","mother_first_name","mother_maiden_name","mother_last_name","father_first_name","father_last_name","was_previously_treated","was_under_15_at_dx","raf_zip","raf_county","birth_year","hospital_no","organization_id","other_diagnosis"

#
#		Models built in block mode to avoid protected attributes
#
			pii = Pii.new do |m|
				m.birth_year         = line['birth_year']
				m.created_at         = line['created_at']
				m.first_name         = line['first_name'] #|| "FIXME"	#	TODO
				m.middle_name        = line['middle_name']
				m.last_name          = line['last_name'] #|| "FIXME"	#	TODO
				m.maiden_name        = line['maiden_name']
				m.died_on            = ( line['died_on'].blank? 
					) ? nil : Time.parse(line['died_on'])
				m.mother_first_name  = line['mother_first_name']
				m.mother_maiden_name = line['mother_maiden_name']
				m.mother_last_name   = line['mother_last_name']
				m.father_first_name  = line['father_first_name']
				m.father_last_name   = line['father_last_name']

				m.dob                = ( line['dob'].blank? 
						) ? nil : Time.parse(line['dob']).to_date
				if line['subject_type_id'].to_i == SubjectType['Mother'].id
					m.subject_is_mother = true
				end

#				if line['subject_type_id'].to_i == SubjectType['Mother'].id
#					m.subject_is_mother = true
#					m.dob               = ( line['dob'].blank? 
#						) ? nil : Time.parse(line['dob']).to_date
#				else
##					#	blank dob only a problem if not mother
##					if line['dob'].blank?
##						error_file.puts 
##						error_file.puts "Line #:#{f.lineno}: No dob and not mother"
##						error_file.puts line
##					end
##					m.dob               = (( line['dob'].blank? 
##						) ? Time.parse('01-Jan-1900') : Time.parse(line['dob']) ).to_date
#					m.dob               = Time.parse(line['dob']).to_date
#				end
			end

			identifier = Identifier.new do |m|
				m.subjectid     = line['subjectid']
				m.childid       = line['childid']
				m.childidwho    = line['childidwho']
				m.icf_master_id = line['icf_master_id']
				m.matchingid    = line['matchingid']
				m.familyid      = line['familyid']
				m.patid         = line['patid']
				m.orderno       = line['orderno']
				m.newid         = line['newid']
				m.studyid       = line['studyid']
				m.state_id_no   = line['state_id_no']
				m.case_control_type = line['case_control_type']
				m.related_case_childid = line['related_case_childid']
				m.created_at         = line['created_at']
			end

			attributes = {
				:created_at      => line['created_at'],
				:subject_type_id => line['subject_type_id'],
				:vital_status_id => line['vital_status_id'],
				:hispanicity_id  => line['hispanicity_id'],
				:do_not_contact  => line['do_not_contact'],
				:sex             => line['sex'],
				:reference_date  => ( line['reference_date'].blank?
						) ? nil : Time.parse(line['reference_date']),
				:pii             => pii,
				:identifier      => identifier
			}

			if line['subject_type_id'].to_i == SubjectType['Case'].id
				patient = Patient.new do |m|
					m.admit_date = ( line['admit_date'].blank?
						) ? nil : Time.parse(line['admit_date'])
					m.diagnosis_id    = line['diagnosis_id']
					m.other_diagnosis = line['other_diagnosis']
					m.organization_id = line['organization_id']
					m.hospital_no     = line['hospital_no']
					m.was_previously_treated = line['was_previously_treated']
					m.was_under_15_at_dx     = line['was_under_15_at_dx']
					m.raf_zip                = line['raf_zip']
					m.raf_county             = line['raf_county']
					m.created_at             = line['created_at']
				end
				attributes[:patient] = patient
			end

			s = StudySubject.create(attributes)
			if s.new_record?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{s.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			end
		end	#	FasterCSV.open
		error_file.close
#		Rake::Task["ccls:data_report"].invoke
	end		#	task :subjects => :environment do

end
