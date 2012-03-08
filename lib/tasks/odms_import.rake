require 'fastercsv'
require 'chronic'

#
#	The purpose of these tasks is to import data extracted from the previous
#	database tables.  THEY ARE DESTRUCTIVE!
#
#	This collection of rake tasks will only be used once.  After its successful 
#	initial usage, I will comment it all out rather than destroy it so that it 
#	can be referenced.  
#

BASEDIR = "/Volumes/BUF-Fileshare/SharedFiles/SoftwareDevelopment\(TBD\)/GrantApp/DataMigration/"
SUBJECTS_CSV = "#{BASEDIR}/ODMS_SubjectData_Combined_xxxxxx.csv"
ADDRESSES_CSV = "#{BASEDIR}/ODMS_Addresses_xxxxxx.csv"
ADDRESSINGS_CSV = "#{BASEDIR}/ODMS_Addressings_xxxxxx.csv"
PHONENUMBERS_CSV = "#{BASEDIR}/ODMS_Phone_Numbers_xxxxxx.csv"
EVENTS_CSV = "#{BASEDIR}/ODMS_Operational_Events_xxxxxx.csv"
ICFMASTERIDS_CSV = "#{BASEDIR}/export_ODMS_ICF_Master_IDs.csv"
ENROLLMENTS_CSV = "#{BASEDIR}/ODMS_Enrollments_xxxxxx.csv"

def format_date(date)
	( date.blank? ) ? nil : date.try(:strftime,"%m/%d/%Y")
end

def format_time_to_date(time)
	( time.blank? ) ? nil : format_date(Time.parse(time).to_date)
end

#	gonna start asserting that everything is as expected.
#	will slow down import, but I want to make sure I get it right.
def assert(expression,message = 'Assertion failed.')
	raise "#{message} :\n #{caller[0]}" unless expression
end

#	Object and not String because could be NilClass
Object.class_eval do
	def nilify_blank
		( self.blank? ) ? nil : self
	end
	def to_nil_or_boolean
		if self.blank?
			nil
		else
			( self.to_i == 1 or self.to_s.upcase == 'TRUE' ) ? true : false
		end
	end
	def to_nil_or_yndk
		if self.blank?
			nil
		else
			( self.upcase == 'TRUE' ) ? YNDK[:yes] : YNDK[:no]
		end
	end
	def to_nil_or_i
		( self.blank? ) ? nil : self.to_i
	end

	#	this is only used for a missing organization_id
#	def to_dk_or_i
#		( self.blank? ) ? 9999999 : self.to_i
#	end

	def only_numeric
		self.to_s.gsub(/\D/,'')
	end
	def to_nil_or_999_or_i
		if self.blank?
			nil
		else
			if self.to_s == '9'
				999
			else
				self.to_i
			end
		end
	end
end

namespace :odms_destroy do

	desc "Destroy subject and address data"
	task :csv_data => :environment do
		puts "Destroying existing data"
		StudySubject.destroy_all
#	subject_races?	currently, there aren't any created
#	subject_languages?	currently, there aren't any created
		Enrollment.destroy_all
		Addressing.destroy_all
		Address.destroy_all
		PhoneNumber.destroy_all
		Interview.destroy_all
		Patient.destroy_all
		Sample.destroy_all
		SampleKit.destroy_all
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

	#
	#	Generates subject_in.csv from Magee's input file.
	#	This file will need sorted before comparison.
	#
	#
	#	GONNA NEED TO SORT THESE TO COMPARE THEM, BUT BEWARE! OF MULTI-LINED ENTRIES
	#
	#
	task :prepare_input_for_comparison => :environment do
		#	Some columns are quoted and some aren't.  Quote all.
		FasterCSV.open('subject_in.csv','w', {:force_quotes=>true}) do |out|
			out.add_row ["subjectid","subject_type_id","vital_status_id","do_not_contact","sex","reference_date","childidwho","hispanicity_id","childid","icf_master_id","matchingid","familyid","patid","case_control_type","orderno","newid","studyid","related_case_childid","state_id_no","admit_date","diagnosis_id","created_at","first_name","middle_name","last_name","maiden_name","dob","died_on","mother_first_name","mother_maiden_name","mother_last_name","father_first_name","father_last_name","was_previously_treated","was_under_15_at_dx","raf_zip","raf_county","birth_year","hospital_no","organization_id","other_diagnosis"]
	
			#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
			(f=FasterCSV.open(SUBJECTS_CSV, 'rb',{ :headers => true })).each do |line|

				#	Not all input records have created_at so nillify all
				line['created_at'] = nil

				#	
				#	Some dates are dates and some are strings so the format is different.
				#
				line['reference_date'] = format_time_to_date( line['reference_date'] )
				line['admit_date'] = format_time_to_date( line['admit_date'] )
				line['dob'] = format_time_to_date( line['dob'] )
				line['died_on'] = format_time_to_date( line['died_on'] )


#	TODO deal with incorrect value 9 in was_* fields
#				if( line['was_previously_treated'].to_s == '9' )
#					puts "Converting was_previously_treated = 9 to 999"
#					puts line
#					line['was_previously_treated'] = '999' 
#					puts line
#				end
#				if( line['was_under_15_at_dx'].to_s == '9' )
#					puts "Converting was_under_15_at_dx = 9 to 999"
#					puts line
#					line['was_under_15_at_dx'] = '999' 
#					puts line
#				end

#				if line['subject_type_id'].to_i == StudySubject.subject_type_case_id &&
#						line['organization_id'].blank?
#
##					#	1 record is missing organization_id so must do this.
##					m.organization_id = ( line['organization_id'].blank? ) ?
##						999 : line['organization_id']
#
#					line['organization_id'] = 999 
#				end

				out.add_row line
			end

		end
	end

	#
	#	Generates a subject_out.csv file from data in the database.
	#
	#
	#	GONNA NEED TO SORT THESE TO COMPARE THEM
	#
	#
	task :csv_dump => :environment do
		puts "Dumping to csv for comparison"

		FasterCSV.open('subject_out.csv','w', {:force_quotes=>true}) do |f|
			f.add_row ["subjectid","subject_type_id","vital_status_id","do_not_contact","sex","reference_date","childidwho","hispanicity_id","childid","icf_master_id","matchingid","familyid","patid","case_control_type","orderno","newid","studyid","related_case_childid","state_id_no","admit_date","diagnosis_id","created_at","first_name","middle_name","last_name","maiden_name","dob","died_on","mother_first_name","mother_maiden_name","mother_last_name","father_first_name","father_last_name","was_previously_treated","was_under_15_at_dx","raf_zip","raf_county","birth_year","hospital_no","organization_id","other_diagnosis"]

			StudySubject.find(:all,
					:order => 'subjectid ASC' ).each do |s|

				f.add_row([
					s.subjectid,
					s.subject_type_id,
					s.vital_status_id,
					s.do_not_contact.to_s.upcase,	# FALSE
					s.sex,
					format_date(s.reference_date),
					s.childidwho,
					s.hispanicity_id,
					s.childid,
					s.icf_master_id,
					s.matchingid,
					s.familyid,
					s.patid,
					s.case_control_type,
					s.orderno,
					s.newid,
					s.studyid,		
					s.related_case_childid,
					s.state_id_no,
					format_date(s.patient.try(:admit_date)),
					s.patient.try(:diagnosis_id),
					nil,
					s.first_name,
					s.middle_name,
					s.last_name,
					s.maiden_name,
					format_date(s.dob),
					format_date(s.died_on),
					s.mother_first_name,
					s.mother_maiden_name,
					s.mother_last_name,
					s.father_first_name,
					s.father_last_name,
					s.patient.try(:was_previously_treated),
					s.patient.try(:was_under_15_at_dx),
					s.patient.try(:raf_zip),
					s.patient.try(:raf_county),
					s.birth_year,
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
		'odms_import:phone_numbers',
		'odms_import:addresses',
		'odms_import:addressings',
#		'odms_import:create_dummy_candidate_controls',
		'ccls:data_report'
	]


	task :addresses => :environment do 
		puts "Destroying addresses"
		Address.destroy_all
		puts "Importing addresses"

		error_file = File.open('addresses_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(ADDRESSES_CSV, 'rb',{ :headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#"address_type_id","data_source_id","line_1","unit","city","state","zip","external_address_id","county","country","created_at"

			address = Address.create({
				:address_type_id => line["address_type_id"],
				:data_source_id  => line["data_source_id"],
				:line_1          => line["line_1"],
				:unit            => line["unit"],
				:city            => line["city"],
				:state           => line["state"],
				:zip             => line["zip"],
				:external_address_id => line["external_address_id"],
				:county          => line["county"],
				:country         => line["country"],
				:created_at      => (( line['created_at'].blank? ) ?
														nil : Time.parse(line['created_at']) )
			})

			if address.new_record?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{address.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			else
				address.reload
				assert address.address_type_id == line["address_type_id"].to_nil_or_i,
					'Address Type mismatch'
				assert address.data_source_id  == line["data_source_id"].to_nil_or_i,
					'Data Source mismatch'
				assert address.line_1          == line["line_1"],
					'Line 1 mismatch'
				assert address.line_2.blank?
					'Line 2 mismatch'
				assert address.unit            == line["unit"],
					'Unit mismatch'
				assert address.city            == line["city"],
					'City mismatch'
				assert address.state           == line["state"],
					'State mismatch'
				assert address.zip.only_numeric == line["zip"].only_numeric,
					'Zip mismatch'
				assert address.external_address_id == line["external_address_id"].to_nil_or_i,
					'External Address mismatch'
				assert address.county          == line["county"],
					'County mismatch'
				assert address.country         == line["country"],
					'Country mismatch'
			end

		end
		error_file.close
	end

	task :addressings => :environment do 
		puts "Destroying addressings"
		Addressing.destroy_all
		puts "Importing addressings"

		error_file = File.open('addressings_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open( ADDRESSINGS_CSV, 'rb',{ :headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#"subjectid","external_address_id","current_address","address_at_diagnosis","valid_from","valid_to","data_source_id","created_at"


			if line['subjectid'].blank?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid blank."
				error_file.puts line
				error_file.puts
				next
			end
			study_subject = StudySubject.find_by_subjectid(line['subjectid'])
			unless study_subject
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid #{line['subjectid']} not found."
				error_file.puts line
				error_file.puts
				next
			end

			address = Address.find_by_external_address_id(line['external_address_id'])
			unless address
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: address with external id #{line['external_address_id']} not found."
				error_file.puts line
				error_file.puts
				next
			end

#			addressing = Addressing.create({
#	study_subject_id is attr_protected
#				:study_subject_id => study_subject.id,
			addressing = study_subject.addressings.create({
				:address_id       => address.id,
				:current_address  => line["current_address"],           # yndk integer
				:address_at_diagnosis => line["address_at_diagnosis"],  # yndk integer
				:valid_from       => (( line['valid_from'].blank? ) ?
														nil : Time.parse(line['valid_from']).to_date ),
				:valid_to         => (( line['valid_to'].blank? ) ?
														nil : Time.parse(line['valid_to']).to_date ),
				:data_source_id   => line["data_source_id"],
				:created_at       => (( line['created_at'].blank? ) ?
														nil : Time.parse(line['created_at']) )
			})

			if addressing.new_record?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{addressing.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			else
				addressing.reload
				assert addressing.study_subject_id == study_subject.id,
					'Study Subject mismatch'
				assert addressing.address_id       == address.id,
					'Address mismatch'
				assert addressing.current_address  == line["current_address"].to_nil_or_i,
					'Current Address mismatch'
				assert addressing.address_at_diagnosis == line["address_at_diagnosis"].to_nil_or_i,
					'Address at Diagnosis mismatch'
				assert addressing.data_source_id == line["data_source_id"].to_nil_or_i,
					'Data Source mismatch'
				if line['valid_from'].blank?
					assert addressing.valid_from.nil?, 'Valid From not nil'
				else
					assert !addressing.valid_from.nil?, 'Valid From is nil'
					assert addressing.valid_from == Time.parse(line['valid_from']).to_date,
						"Valid From mismatch"
				end
				if line['valid_to'].blank?
					assert addressing.valid_to.nil?, 'Valid To not nil'
				else
					assert !addressing.valid_to.nil?, 'Valid To is nil'
					assert addressing.valid_to == Time.parse(line['valid_to']).to_date,
						"Valid To mismatch"
				end
			end

		end
		error_file.close
	end

	task :phone_numbers => :environment do 
		puts "Destroying phone_numbers"
		PhoneNumber.destroy_all
		puts "Importing phone_numbers"

		error_file = File.open('phone_numbers_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(PHONENUMBERS_CSV, 'rb',{ :headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#"subjectid","data_source_id","external_address_id","created_at","phone_number","is_primary","current_phone","phone_type_id"

			if line['subjectid'].blank?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid blank."
				error_file.puts line
				error_file.puts
				next
			end
			study_subject = StudySubject.find_by_subjectid(line['subjectid'])
			unless study_subject
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid #{line['subjectid']} not found."
				error_file.puts line
				error_file.puts
				next
			end

			phone_number = study_subject.phone_numbers.create({
#			phone_number = PhoneNumber.create({
#	study_subject_id is attr_protected
#				:study_subject_id => study_subject.id,
				:phone_type_id    => line["phone_type_id"],
				:data_source_id   => line["data_source_id"],
				:phone_number     => line["phone_number"],
				:is_primary       => line["is_primary"],         #	boolean
				:current_phone    => line["current_phone"],      #	yndk integer
#				:current_phone    => line["current_phone"].to_nil_or_yndk,
				:created_at       => (( line['created_at'].blank? ) ?
														nil : Time.parse(line['created_at']) )
			})

			if phone_number.new_record?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{phone_number.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			else
				phone_number.reload
				assert phone_number.study_subject_id == study_subject.id, 
					"Study Subject mismatch"
				assert phone_number.phone_type_id == line["phone_type_id"].to_nil_or_i,
					"phone_type_id mismatch:#{phone_number.phone_type_id}:#{line["phone_type_id"]}:"
				assert phone_number.data_source_id == line["data_source_id"].to_nil_or_i,
					"data_source_id mismatch:#{phone_number.data_source_id}:#{line["data_source_id"]}:"
				#	import will change format of phone number (adds () and - )
				assert phone_number.phone_number.only_numeric == line["phone_number"].only_numeric,
					"phone_number mismatch:#{phone_number.phone_number}:#{line["phone_number"]}:"
#				assert phone_number.current_phone == line["current_phone"].to_nil_or_yndk,
				assert phone_number.current_phone == line["current_phone"].to_nil_or_i,
					"current_phone mismatch:#{phone_number.current_phone}:#{line["current_phone"]}:"
				assert phone_number.is_primary       == line["is_primary"].to_nil_or_boolean, 
					"is_primary mismatch:#{phone_number.is_primary}:#{line["is_primary"]}:"
			end

		end
		error_file.close
	end

	task :operational_events => :environment do 
#	Can't destroy them as there will be some already
#	Actually, this seems to include the subject creation event
#		so destruction may be just fine.
#		puts "Destroying operational_events"
#		OperationalEvent.destroy_all
		puts "Importing operational_events"

		error_file = File.open('operational_events_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(EVENTS_CSV, 'rb',{ :headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

#"subjectID","project_id","operational_event_id","occurred_on","description","enrollment_id","event_notes"

			study_subject = StudySubject.find_by_subjectid(line['subjectID'])	#	misnamed field
			unless study_subject
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid #{line['subjectID']} not found."
				error_file.puts line
				error_file.puts
				next
			end

			ccls_enrollment = study_subject.enrollments.find_by_project_id(line['project_id'])
			operational_event = OperationalEvent.create({
				:enrollment_id => ccls_enrollment.id,
				:operational_event_type_id => line['operational_event_id'],	#	NOTE misnamed field
				:occurred_on => Time.parse(line['occurred_on']).to_date,
				:description => line['description'],
				:event_notes => line['event_notes']
			})
			if operational_event.new_record?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{operational_event.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			else
				operational_event.reload
				assert operational_event.enrollment_id == ccls_enrollment.id,
					"Enrollment mismatch"
				assert operational_event.operational_event_type_id == line['operational_event_id'].to_nil_or_i, 
					"operational_event_type mismatch:#{operational_event.operational_event_type_id}:#{line["operational_event_id"]}:"
				assert operational_event.occurred_on == Time.parse(line['occurred_on']).to_date,
					"occurred_on mismatch:#{operational_event.occurred_on}:#{line["occurred_on"]}:"
				assert operational_event.description == line['description'],
					"description mismatch:#{operational_event.description}:#{line["description"]}:"
				assert operational_event.event_notes == line['event_notes'],
					"event_notes mismatch:#{operational_event.event_notes}:#{line["event_notes"]}:"
			end
		end
		error_file.close
	end

	task :icf_master_ids => :environment do 
		puts "Destroying icf_master_ids"
		IcfMasterId.destroy_all
		puts "Importing icf_master_ids"

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(ICFMASTERIDS_CSV, 'rb',{ :headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			raise "Given icf_master_id is blank?" if line['icf_master_id'].blank?

			attributes = { :icf_master_id => line['icf_master_id'] }




#
#	subjectid is unique so this should NEVER happen
#
			if line['subjectid'] and !line['subjectid'].blank?
				study_subjects = StudySubject.find(:all,
					:conditions => { :subjectid => line['subjectid'] } )
				case 
					when study_subjects.length > 1
						raise "More than one study_subject found matching subjectid:#{line['subjectid']}:"
					when study_subjects.length == 0
						raise "No study_subject found matching subjectid:#{line['subjectid']}:"
					else
						puts "Found study_subject matching subjectid:#{line['subjectid']}:"
				end
				study_subject = study_subjects.first






				#	Fortunately, these never happen
				if study_subject.icf_master_id.blank?
					#	assign it?
					raise "ICF Master ID isn't actually set in the StudySubject!"
				else
					#	different?
					if study_subject.icf_master_id != line['icf_master_id']
						raise "ICF Master ID is different than that set in the StudySubject!\n" <<
							"#{study_subject.icf_master_id}:#{line['icf_master_id']}"
					end
				end


				attributes[:study_subject_id] = study_subject.id
				attributes[:assigned_on] = Time.parse(line['assigned_on'])
			else
				#	I just noticed that some of the icf_master_ids are actually
				#	assigned in the subject data, but not marked as being
				#	assigned in the icf_master_id list.  So, search for them.
				study_subjects = StudySubject.find(:all,
					:conditions => { :icf_master_id => line['icf_master_id'] } )
				case 
#
#	icf_master_id is unique, so should NEVER find more than 1 unless it is nil.
#
					when study_subjects.length > 1
						raise "More than one study_subject found matching icf_master_id:#{line['icf_master_id']}:"
#					when study_subjects.length == 0
#						raise "No study_subject found matching icf_master_id:#{line['icf_master_id']}:"
					when study_subjects.length == 1
						puts "Found study_subject matching icf_master_id:#{line['icf_master_id']}:"
						attributes[:study_subject_id] = study_subjects.first.id
						attributes[:assigned_on] = Date.today
				end
			end

			IcfMasterId.create!(attributes)
		end

	end


#	task :create_dummy_candidate_controls => :environment do
##		puts "Destroying candidate controls"
##		CandidateControl.destroy_all
#		puts "Creating dummy candidate controls"
#		SubjectType['Case'].study_subjects.each do |s|
#			rand(5).times do |i|
#				puts "Creating candidate control for study_subject_id:#{s.id}"
#				CandidateControl.create!({
#					:related_patid => s.patid,
#					:first_name => "First#{i}",
#					:last_name  => "Last#{s.id}",
#					:sex        => ['M','F'][rand(2)],
#					:dob        => Date.jd(2440000+rand(15000))
#				})
#			end
#		end
#		
#		printf "%-19s %5d\n", "CandidateControl.count:", CandidateControl.count
#	end

	desc "Import data from enrollments.csv file"
	task :enrollments => :environment do
		puts "Importing enrollments"

#		error_file = File.open('enrollments_errors.txt','a')	#	append existing
		error_file = File.open('enrollments_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(ENROLLMENTS_CSV, 'rb',{ :headers => true })).each do |line|

#	skip until ...
#			next if f.lineno <= 10619

			puts "Processing line #{f.lineno}"
			puts line

#	Don't need all of this and don't know exactly what to do with the DeclineReasons
#	also is_eligible changed and ineligible_reason_id added
#"subjectType-donotimprot","ChildId","project_id","subjectID","consented","consented_on","tPatientInfo_DeclineReason","tlDeclineReasons_DeclineReason","refusal_reason_id","document_version_id","is_eligible","ineligible_reason_id"

			if line['subjectID'].blank?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid blank."
				error_file.puts line
				error_file.puts
				next
			end
			study_subject = StudySubject.find_by_subjectid(line['subjectID'])	#	misnamed field
			unless study_subject
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: subjectid #{line['subjectID']} not found."
				error_file.puts line
				error_file.puts
				next
			end

			enrollment = study_subject.enrollments.find_or_create_by_project_id(
				line['project_id'])

			#	TEMPORARY "FIXES" to get most enrollments imported

			consented           = line['consented']
			consented_on        = (( line['consented_on'].blank? ) ?
					nil : Time.parse(line['consented_on']).to_date )
#			consented_on        = if [nil,999,'','999'].include?(consented)
#				nil
#			else
#				(( line['consented_on'].blank? ) ?
#					nil : Time.parse(line['consented_on']).to_date )
#			end
			refusal_reason_id   = line['refusal_reason_id']
#			refusal_reason_id   = if consented.to_i == 2
#				line['refusal_reason_id']
#			else
#				nil
#			end
			document_version_id = line['document_version_id']
#			document_version_id = if [nil,999,'','999'].include?(consented)
#				nil
#			else
#				line['document_version_id']
#			end

			#	END	TEMPORARY "FIXES" to get most enrollments imported

			saved = enrollment.update_attributes(
				:consented           => consented,
				:consented_on        => consented_on,
				:refusal_reason_id   => refusal_reason_id,
#				:other_refusal_reason => line['tlDeclineReasons_DeclineReason'],


#	TODO
#				:document_version_id => document_version_id,



				:is_eligible         => line['is_eligible'],
				:ineligible_reason_id => line['ineligible_reason_id']
			)
			unless saved
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{enrollment.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts enrollment.inspect
				error_file.puts
			else
				enrollment.reload
				assert enrollment.consented == line['consented'].to_nil_or_i,
					"consented mismatch:#{enrollment.consented}:#{line["consented"]}:"
				assert enrollment.consented_on        == consented_on,
					"consented_on mismatch:#{enrollment.consented_on}:#{line["consented_on"]}:"
				assert enrollment.refusal_reason_id   == refusal_reason_id.to_nil_or_i,
					"refusal_reason_id mismatch:#{enrollment.refusal_reason_id}:#{line["refusal_reason_id"]}:"


#	TODO
#				assert enrollment.document_version_id == document_version_id.to_nil_or_i,
#					"document_version_id mismatch:#{enrollment.document_version_id}:#{line["document_version_id"]}:"


				assert enrollment.is_eligible == line['is_eligible'].to_nil_or_i,
					"is_eligible mismatch:#{enrollment.is_eligible}:#{line['is_eligible']}:"
				assert enrollment.ineligible_reason_id   == line['ineligible_reason_id'].to_nil_or_i,
					"ineligible_reason_id mismatch:#{enrollment.ineligible_reason_id}:#{line["ineligible_reason_id"]}:"
			end

		end
		error_file.close
	end


	desc "Import data from subjects.csv file"
	task :subjects => :environment do
		puts "Importing subjects"

#		error_file = File.open('subjects_errors.txt','a')	#	append existing
		error_file = File.open('subjects_errors.txt','w')	#	overwrite existing

		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(SUBJECTS_CSV, 'rb',{ :headers => true })).each do |line|

#	skip until ...
#			next if f.lineno <= 10619

			puts "Processing line #{f.lineno}"
			puts line

#"subjectid","subject_type_id","vital_status_id","do_not_contact","sex","reference_date","childidwho","hispanicity_id","childid","icf_master_id","matchingid","familyid","patid","case_control_type","orderno","newid","studyid","related_case_childid","state_id_no","admit_date","diagnosis_id","created_at","first_name","middle_name","last_name","maiden_name","dob","died_on","mother_first_name","mother_maiden_name","mother_last_name","father_first_name","father_last_name","was_previously_treated","was_under_15_at_dx","raf_zip","raf_county","birth_year","hospital_no","organization_id","other_diagnosis","father_hispanicity_id","mother_hispanicity_id"



#
#		Models built in block mode to avoid protected attributes
#

			s = StudySubject.new do |x|
				x.subject_type_id = line['subject_type_id']
				x.hispanicity_id  = line['hispanicity_id']
				x.father_hispanicity_id  = line['father_hispanicity_id']
				x.mother_hispanicity_id  = line['mother_hispanicity_id']
#
#	do_not_contact is a boolean string in the csv file.
#	It does seem to convert correctly in the database.
				x.do_not_contact  = line['do_not_contact']

				x.sex             = line['sex']
				x.reference_date  = ( line['reference_date'].blank?
						) ? nil : Time.parse(line['reference_date'])

				x.birth_year         = line['birth_year']
				x.first_name         = line['first_name']
				x.middle_name        = line['middle_name']
				x.last_name          = line['last_name']
				x.maiden_name        = line['maiden_name']
				x.died_on            = ( line['died_on'].blank? 
					) ? nil : Time.parse(line['died_on'])
				x.mother_first_name  = line['mother_first_name']
				x.mother_maiden_name = line['mother_maiden_name']
				x.mother_last_name   = line['mother_last_name']
				x.father_first_name  = line['father_first_name']
				x.father_last_name   = line['father_last_name']

				x.dob                = ( line['dob'].blank? 
						) ? nil : Time.parse(line['dob']).to_date

				x.subjectid     = line['subjectid']
				x.childid       = line['childid']
				x.childidwho    = line['childidwho']
				x.icf_master_id = line['icf_master_id']
				x.matchingid    = line['matchingid']
				x.familyid      = line['familyid']
				x.patid         = line['patid']
				x.orderno       = line['orderno']
				x.newid         = line['newid']
				x.studyid       = line['studyid']
				x.state_id_no   = line['state_id_no']
				x.case_control_type = line['case_control_type']
				x.related_case_childid = line['related_case_childid']
				x.created_at         = line['created_at']

				unless line['vital_status_id'].blank?
					x.vital_status_id = line['vital_status_id']
#				else leave as database default
				end
			end

			if line['subject_type_id'].to_i == StudySubject.subject_type_case_id
				patient = Patient.new do |m|
					m.admit_date = ( line['admit_date'].blank?
						) ? nil : Time.parse(line['admit_date'])
					m.diagnosis_id    = line['diagnosis_id']
					m.other_diagnosis = line['other_diagnosis']




					#	1 record is missing organization_id so must do this. (9999999)
#					m.organization_id = line['organization_id'].to_dk_or_i
					m.organization_id = line['organization_id']





					m.hospital_no     = line['hospital_no']

#	TODO deal with incorrect value 9 in was_* fields

					m.was_previously_treated = line['was_previously_treated'].to_nil_or_999_or_i
#					m.was_previously_treated = line['was_previously_treated']
#	kinda pointless as is set in callback
#					m.was_under_15_at_dx     = line['was_under_15_at_dx'].to_nil_or_999_or_i
					m.was_under_15_at_dx     = line['was_under_15_at_dx']

					m.raf_zip                = line['raf_zip']
					m.raf_county             = line['raf_county']
					m.created_at             = line['created_at']
				end
				s.patient = patient
			end
			s.save

			if s.new_record?
				error_file.puts 
				error_file.puts "Line #:#{f.lineno}: #{s.errors.full_messages.to_sentence}"
				error_file.puts line
				error_file.puts
			else
				s.reload
				compare_subject_and_line(s,line)
			end
		end	#	FasterCSV.open
		error_file.close
	end		#	task :subjects => :environment do

end	#	namespace :odms_import do

namespace :odms_compare do
	desc "Compare data from subjects.csv file"
	task :subjects => :environment do
		puts "Comparing subjects"
		warn_file = File.open('subjects_warnings.txt','w')	#	overwrite existing
		#	DO NOT COMMENT OUT THE HEADER LINE OR IT RAISES CRYPTIC ERROR
		(f=FasterCSV.open(SUBJECTS_CSV, 'rb',{ :headers => true })).each do |line|
			puts "Processing line #{f.lineno}"
			puts line

			s = StudySubject.find_by_subjectid(line['subjectid'])
			if s
				compare_subject_and_line(s,line,warn_file)
			else
				warn_file.puts "Subject not found with subjectid:#{line['subjectid']}"
				warn_file.puts
			end

		end	#	FasterCSV.open
		warn_file.close
	end		#	task :subjects => :environment do
end	#	namespace :odms_compare do

def compare_subject_and_line(s,line,warn_file=nil)
#
#	TODO Add a "warnings" file containing some of these changes?
#			Some may actually occur on the import of another subject though.
#			Would have to loop to loop through the csv file again to actually compare.
#

				assert s.subject_type_id == line['subject_type_id'].to_nil_or_i,
					"subject_type_id mismatch:#{s.subject_type_id}:#{line['subject_type_id']}:"

				if line['vital_status_id'].blank?
					assert s.vital_status_id == 1,
						"Vital Status not set to default"
				else
					assert s.vital_status_id.to_s == line['vital_status_id'],
						"Vital Status mismatch:#{s.vital_status_id}:#{line['vital_status_id']}:"
				end

#	TODO 	TRUE / FALSE
				assert s.do_not_contact == line['do_not_contact'].to_nil_or_boolean,
					'Do Not Contact mismatch'
				assert s.sex == line['sex'],
					"sex mismatch:#{s.sex}:#{line['sex']}:"
				assert s.hispanicity_id == line['hispanicity_id'].to_nil_or_i,
					"hispanicity_id mismatch:#{s.hispanicity_id}:#{line['hispanicity_id']}:"
				assert s.mother_hispanicity_id == line['mother_hispanicity_id'].to_nil_or_i,
					"mother_hispanicity_id mismatch:#{s.mother_hispanicity_id}:#{line['mother_hispanicity_id']}:"
				assert s.father_hispanicity_id == line['father_hispanicity_id'].to_nil_or_i,
					"father_hispanicity_id mismatch:#{s.father_hispanicity_id}:#{line['father_hispanicity_id']}:"

#	TODO not always be true due to callbacks
#				if line['reference_date'].blank?
#					assert s.reference_date.nil?, 'reference_date not nil'
#				else
#					assert !s.reference_date.nil?, 'reference_date nil'
#					assert s.reference_date == Time.parse(line['reference_date']),
#						"reference_date mismatch:#{s.reference_date}:#{line['reference_date']}:"
#				end

				unless warn_file.nil?

					#	reference_date is changed to Patient#admit_date for all matching matchingid
					#		when matchingid or admit_date changes
					#	FYI ... During import, the case may not exist yet.
					matching_case = if s.is_case?
						s
					else
						matching_cases = StudySubject.find(:all,	#	should only be one
							:conditions => { 
								:subject_type_id => StudySubject.subject_type_case_id,
								:matchingid      => s.matchingid
							})
						#	still in testing so there isn't always one
						raise "There can be only One!" if matching_cases.length > 1
#						raise "There must be One!" if matching_cases.length < 1
						( matching_cases.length == 1 ) ? matching_cases[0] : nil
					end

					if line['reference_date'].blank? 
						if !s.reference_date.nil?
							warn_file.puts s.inspect
							warn_file.puts "-reference_date not nil:"
							warn_file.puts "-reference_date csv :#{line['reference_date']}:" 
							warn_file.puts "-reference_date db  :#{s.reference_date}:"
if matching_case
							warn_file.puts "-case admit_date    :#{matching_case.admit_date}:"
else
							warn_file.puts "-case admit_date    :no case found:"
end
							warn_file.puts
						end
					else
						if s.reference_date != Time.parse(line['reference_date']).to_date
							warn_file.puts s.inspect
							warn_file.puts "-reference_date mismatch:"
							warn_file.puts "-reference_date csv :#{line['reference_date']}:" 
							warn_file.puts "-reference_date db  :#{s.reference_date}:"
if matching_case
							warn_file.puts "-case admit_date    :#{matching_case.admit_date}:"
else
							warn_file.puts "-case admit_date    :no case found:"
end
							warn_file.puts
						end
					end
				end

				assert s.first_name == line['first_name'],
					"first_name mismatch:#{s.first_name}:#{line['first_name']}:"
				assert s.middle_name == line['middle_name'],
					"middle_name mismatch:#{s.middle_name}:#{line['middle_name']}:"
				assert s.last_name == line['last_name'],
					"last_name mismatch:#{s.last_name}:#{line['last_name']}:"
				assert s.maiden_name == line['maiden_name'],
					"maiden_name mismatch:#{s.maiden_name}:#{line['maiden_name']}:"

				if line['dob'].blank?
					assert s.dob.nil?, 'dob not nil'
				else
					assert !s.dob.nil?, 'dob nil'
					assert s.dob == Time.parse(line['dob']).to_date,
						"dob mismatch:#{s.dob}:#{line['dob']}:"
				end
				if line['died_on'].blank?
					assert s.died_on.nil?, 'died_on not nil'
				else
					assert !s.died_on.nil?, 'died_on nil'
					assert s.died_on == Time.parse(line['died_on']).to_date,
						"died_on mismatch:#{s.died_on}:#{line['died_on']}:"
				end

				assert s.mother_first_name == line['mother_first_name'],
					"mother_first_name mismatch:#{s.mother_first_name}:#{line['mother_first_name']}:"
				assert s.mother_maiden_name == line['mother_maiden_name'],
					"mother_maiden_name mismatch:#{s.mother_maiden_name}:#{line['mother_maiden_name']}:"
				assert s.mother_last_name == line['mother_last_name'],
					"mother_last_name mismatch:#{s.mother_last_name}:#{line['mother_last_name']}:"
				assert s.father_first_name == line['father_first_name'],
					"father_first_name mismatch:#{s.father_first_name}:#{line['father_first_name']}:"
				assert s.father_last_name == line['father_last_name'],
					"father_last_name mismatch:#{s.father_last_name}:#{line['father_last_name']}:"
				assert s.birth_year == line['birth_year'],
					"birth_year mismatch:#{s.birth_year}:#{line['birth_year']}:"


				pa = s.patient
				if s.subject_type == SubjectType['case']
					pa.reload

#	TODO may not always be true
					if line['admit_date'].blank?
						assert pa.admit_date.nil?, 'admit_date not nil'
					else
						assert !pa.admit_date.nil?, 'admit_date nil'
						assert pa.admit_date == Time.parse(line['admit_date']).to_date,
							'admit_date mismatch'
					end

#					unless warn_file.nil?
#						if pa.admit_date != Time.parse(line['admit_date']).to_date
##	don't think that this happens
#raise "i guess that it does"
#							warn_file.puts s.inspect
#							warn_file.puts pa.inspect
#							warn_file.puts "-admit_date mismatch:"
#							warn_file.puts "-admit_date csv :#{line['admit_date']}:" 
#							warn_file.puts "-admit_date db  :#{pa.admit_date}:"
#							warn_file.puts 
#						end
#					end


					assert pa.diagnosis_id == line['diagnosis_id'].to_nil_or_i,
						"diagnosis_id mismatch:#{pa.diagnosis_id}:#{line['diagnosis_id']}:"
					assert pa.raf_zip.only_numeric == line['raf_zip'].only_numeric,
						"raf_zip mismatch:#{pa.raf_zip}:#{line['raf_zip']}:"
					assert pa.raf_county == line['raf_county'],
						"raf_county mismatch:#{pa.raf_county}:#{line['raf_county']}:"
					assert pa.hospital_no == line['hospital_no'],
						"hospital_no mismatch:#{pa.hospital_no}:#{line['hospital_no']}:"


# TODO
#					assert pa.organization_id == line['organization_id'].to_dk_or_i,
					assert pa.organization_id == line['organization_id'].to_nil_or_i,
						"organization_id mismatch:#{pa.organization_id}:#{line['organization_id']}:"


					assert pa.other_diagnosis == line['other_diagnosis'],
						"other_diagnosis mismatch:#{pa.other_diagnosis}:#{line['other_diagnosis']}:"

#	TODO problem with the 9 and 999 issue as well
#					assert pa.was_previously_treated == line['was_previously_treated'].to_nil_or_i,
					assert pa.was_previously_treated == line['was_previously_treated'].to_nil_or_999_or_i,
						"was_previously_treated mismatch:#{pa.was_previously_treated}:#{line['was_previously_treated']}:"
#	TODO probably won't be true all the time
#					assert pa.was_under_15_at_dx == line['was_under_15_at_dx'],
#						'was_under_15_at_dx mismatch'

					unless warn_file.nil?
						if pa.was_under_15_at_dx != line['was_under_15_at_dx'].to_nil_or_i
							warn_file.puts s.inspect
							warn_file.puts pa.inspect
							warn_file.puts "was_under_15_at_dx mismatch:"
							warn_file.puts "was_under_15_at_dx csv :#{line['was_under_15_at_dx']}:" 
							warn_file.puts "was_under_15_at_dx db  :#{pa.was_under_15_at_dx}:"
							warn_file.puts "dob db           :#{s.dob}:"
							warn_file.puts "admit_date db    :#{pa.admit_date}:"
							warn_file.puts "admit_date - dob :#{((pa.admit_date.to_date - s.dob.to_date).to_f/365)}:"
							warn_file.puts
						end
					end

				else
					assert pa.nil?, 'Patient for non-case'
				end

				assert s.subjectid == line['subjectid'],
					"subjectid mismatch:#{s.subjectid}:#{line['subjectid']}:"
				assert s.childid.to_s == line['childid'],
					"childid mismatch:#{s.childid}:#{line['childid']}:"
				assert s.icf_master_id == line['icf_master_id'],
					"icf_master_id mismatch:#{s.icf_master_id}:#{line['icf_master_id']}:"
				assert s.childidwho == line['childidwho'],
					"childidwho mismatch:#{s.childidwho}:#{line['childidwho']}:"
				assert s.familyid == line['familyid'],
					"familyid mismatch:#{s.familyid}:#{line['familyid']}:"
				assert s.matchingid == line['matchingid'],
					"matchingid mismatch:#{s.matchingid}:#{line['matchingid']}:"
				assert s.patid == line['patid'],
					"patid mismatch:#{s.patid}:#{line['patid']}:"
				assert s.case_control_type == line['case_control_type'],
					"case_control_type mismatch:#{s.case_control_type}:#{line['case_control_type']}:"
				assert s.orderno == line['orderno'].to_nil_or_i,
					"orderno mismatch:#{s.orderno}:#{line['orderno']}:"
				assert s.newid == line['newid'],
					"newid mismatch:#{s.newid}:#{line['newid']}:"
				assert s.studyid == line['studyid'],
					"studyid mismatch:#{s.studyid}:#{line['studyid']}:"
				assert s.related_case_childid == line['related_case_childid'],
					"related_case_childid mismatch:#{s.related_case_childid}:#{line['related_case_childid']}:"
				assert s.state_id_no == line['state_id_no'],
					"state_id_no mismatch:#{s.state_id_no}:#{line['state_id_no']}:"
end
