class IcfMasterTracker < ActiveRecordShared

	has_attached_file :csv_file,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/icf_master_tracker.yml')
		))).result)[Rails.env]


	#	This doesn't really do much of anything yet.
	def parse
		results = []
		if !self.csv_file_file_name.blank? &&
				File.exists?(self.csv_file.path)
			(f=FasterCSV.open( self.csv_file.path, 'rb',{
				:headers => true })).each do |line|

#	"Masterid","Motherid","Record_Owner","Datereceived","Lastatt","Lastdisp","Currphone","Vacauthrecd","Recollect","Needpreincentive","Active_Phone","Recordsentformatching","Recordreceivedfrommatching","Sentpreincentive","Releasedtocati","Confirmedcaticontact","Refused","Deceasednotification","Eligible","Confirmationpacketsent","Catiprotocolexhausted","Newphonenumreleasedtocati","Pleanotificationsent","Casereturnedtoberkeleyfornewinf","Casereturnedfromberkeley","Caticomplete","Kitmothersent","Kitinfantsent","Kitchildsent","Kitadolescentsent","Kitmotherrefusedcode","Kitchildrefusedcode","Noresponsetoplea","Responsereceivedfromplea","Senttoinpersonfollowup","Kitmotherrecd","Kitchildrecvd","Thankyousent","Physrequestsent","Physresponsereceived"


				identifier = Identifier.find_by_icf_master_id(line['Masterid'])
				if identifier
					results.push(identifier.study_subject)
				else
					results.push("Could not find identifier with masterid #{line['Masterid']}")
					next
				end


#				elsif line['ca_co_status'] == 'control'
#					identifier = Identifier.find_by_icf_master_id(line['masterid'])
#					if identifier
##						puts "Found identifier with masterid #{line['masterid']}"
#					else
##						puts "Could not find identifier with masterid #{line['masterid']}"
##						results.push(nil)
#						results.push("Could not find identifier with masterid #{line['masterid']}")
#						next
#					end
#
#					dob = Date.new(line['child_doby'].to_i, line['child_dobm'].to_i, line['child_dobd'].to_i)
##					child_names  = split_name(line["child_full_name"])
##					father_names = split_name(line["father_full_name"])
##					mother_names = split_name(line["mother_full_name"])
#					child_names  = line["child_full_name"].split_name
#					father_names = line["father_full_name"].split_name
#					mother_names = line["mother_full_name"].split_name
##"mother_full_name":"Jill Johnson" 	#	parse into first, middle and last
##"father_full_name":"Jack Johnson" 	#	parse into first, middle and last
##"child_full_name":"Michael Johnson" 	#	parse into first, middle and last
#
#					candidate_control_options = {
#						:related_patid => identifier.patid,
#						:mom_is_biomom => line["biomom"],
#						:dad_is_biodad => line["biodad"],
##"date":nil 	#	some event's occurred on
#						:first_name  => child_names[0],
#						:middle_name => child_names[1],
#						:last_name   => child_names[2],
##						:father_first_name  => father_names[0],	#	doesn't exist
##						:father_middle_name => father_names[1],	#	doesn't exist
##						:father_last_name   => father_names[2],	#	doesn't exist
#						:mother_first_name  => mother_names[0],
#						:mother_middle_name => mother_names[1],
#						:mother_last_name   => mother_names[2],
#						:mother_maiden_name => line["mother_maiden_name"],
#						:dob => dob,
#						:sex => line["child_gender"],
##"birthplace_country":"United States" 	#	doesn't exist
##"birthplace_state":"CA" 	#	doesn't exist
##"birthplace_city":"Oakland" 	#	doesn't exist
#						:mother_hispanicity_id => line["mother_hispanicity"],
##"mother_hispanicity_mex":"2" 	#	doesn't exist
#						:mother_race_id => line["mother_race"],
##"mother_race_other":nil 	#	doesn't exist
#						:father_hispanicity_id => line["father_hispanicity"],
##"father_hispanicity_mex":"2" 	#	doesn't exist
#						:father_race_id => line["father_race"]
##"father_race_other":nil	#	doesn't exist
#					}
#					candidate_control = CandidateControl.find(:first,
#						:conditions => candidate_control_options )
#
#
#					if candidate_control.nil?
#						candidate_control = CandidateControl.create( candidate_control_options )
#						#	TODO what if there's an error?
#					end
##					unless candidate_control.new_record?
##						results.push(candidate_control.id)
##					end
#					results.push(candidate_control)
#
#				else
##	TODO TEST don't know this ca_co_status
##					results.push(nil)
#					results.push("Unexpected ca_co_status :#{line['ca_co_status']}:")
#				end	#	elsif line['ca_co_status'] == 'control'

			end	#	(f=FasterCSV.open( self.csv_file.path, 'rb',{ :headers => true })).each do |line|
		end	#	if !self.csv_file_file_name.blank? && File.exists?(self.csv_file.path)
		results	#	TODO why am I returning anything?  will I use this later?
	end	#	def parse

end
