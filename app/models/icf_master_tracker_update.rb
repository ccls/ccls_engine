class IcfMasterTrackerUpdate < ActiveRecordShared

	has_attached_file :csv_file,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/icf_master_tracker_update.yml')
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


#
#	I think that I am going to create a table and model IcfMasterTracker
#	which will basically be identical to this file.  I will find or create
#	by masterid and then update all of the columns.
#
#	The IcfMasterTracker will include an after_save or something that will
#	determine what has changed and update appropriately.  It may also
#	Create OperationalEvents to document the data changes.  As it is
#	theoretically possible that the masterid does not exist in the identifiers
#	table, perhaps add a successfully_updated_models flag which could
#	be used?
#


			end	#	(f=FasterCSV.open( self.csv_file.path, 'rb',{ :headers => true })).each
		end	#	if !self.csv_file_file_name.blank? && File.exists?(self.csv_file.path)
		results	#	TODO why am I returning anything?  will I use this later?
	end	#	def parse

end
