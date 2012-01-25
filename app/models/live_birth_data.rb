class LiveBirthData < ActiveRecordShared

	has_attached_file :csv_file,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/live_birth_data.yml')
		))).result)[Rails.env]

	def to_candidate_controls
		if !self.csv_file_file_name.blank? &&
				File.exists?(self.csv_file.path)
			(f=FasterCSV.open( self.csv_file.path, 'rb',{
				:headers => true })).each do |line|

#<FasterCSV::Row "masterid":"1234FAKE" "ca_co_status":"case" "biomom":"1" "biodad":nil "date":"1/18/2012" "mother_full_name":"Jane Smith" "mother_maiden_name":"Jones" "father_full_name":"John Smith" "child_full_name":"Jimmy Smith" "child_dobm":"1" "child_dobd":"6" "child_doby":"2009" "child_gender":"M" "birthplace_country":"United States" "birthplace_state":"CA" "birthplace_city":"Bakersfield" "mother_hispanicity":"2" "mother_hispanicity_mex":"2" "mother_race":"1" "mother_race_other":nil "father_hispanicity":"2" "father_hispanicity_mex":"2" "father_race":"1" "father_race_other":nil>
#<FasterCSV::Row "masterid":"1234FAKE" "ca_co_status":"control" "biomom":"1" "biodad":nil "date":nil "mother_full_name":"Jill Johnson" "mother_maiden_name":"Jackson" "father_full_name":"Jack Johnson" "child_full_name":"Michael Johnson" "child_dobm":"1" "child_dobd":"6" "child_doby":"2009" "child_gender":"M" "birthplace_country":"United States" "birthplace_state":"CA" "birthplace_city":"Oakland" "mother_hispanicity":"2" "mother_hispanicity_mex":"2" "mother_race":"1" "mother_race_other":nil "father_hispanicity":"2" "father_hispanicity_mex":"2" "father_race":"1" "father_race_other":nil>

				#	just skip the case lines
				if line['ca_co_status'] == 'control'
#	case = find by masterid
#	what if none found?
#	check for existing candidate control?
#	patid = case.patid
#					candidate_control = CandidateControl.new({
#						:related_patid => patid,
#						:mom_is_biomom => line["biomom"],
#						:dad_is_biodad => line["biodad"],
#"date":nil 	#	some event's occurred on
#"mother_full_name":"Jill Johnson" 	#	parse into first, middle and last
#						:mother_maiden_name => line["mother_maiden_name"],
#"father_full_name":"Jack Johnson" 	#	parse into first, middle and last
#"child_full_name":"Michael Johnson" 	#	parse into first, middle and last
#"child_dobm":"1" 	#	compile into dob
#"child_dobd":"6" 	#	compile into dob
#"child_doby":"2009" 	#	compile into dob
#						:sex => line["child_gender"],
#"birthplace_country":"United States" 	#	doesn't exist
#"birthplace_state":"CA" 	#	doesn't exist
#"birthplace_city":"Oakland" 	#	doesn't exist
#						:mother_hispanicity_id => line["mother_hispanicity"],
#"mother_hispanicity_mex":"2" 	#	doesn't exist
#						:mother_race_id => line["mother_race"],
#"mother_race_other":nil 	#	doesn't exist
#						:father_hispanicity_id => line["father_hispanicity"],
#"father_hispanicity_mex":"2" 	#	doesn't exist
#						:father_race_id => line["father_race"],
#"father_race_other":nil	#	doesn't exist
#					})

#puts line.inspect
#	save
#	errors?
				end
			end 
		end 
	end

end
