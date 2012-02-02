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

#
#	The IcfMasterTracker will include an after_save or something that will
#	determine what has changed and update appropriately.  It may also
#	create OperationalEvents to document the data changes.  As it is
#	theoretically possible that the Masterid does not exist in the identifiers
#	table, perhaps add a successfully_updated_models flag which could
#	be used?
#
				icf_master_tracker = IcfMasterTracker.find_or_create_by_Masterid(line['Masterid'])
				#	NO BANG. Don't want to raise any errors.
				successfully_updated = icf_master_tracker.update_attributes(line.to_hash)
#
#	errors = icf_master_tracker.errors.full_messages.to_sentence
#	These won't be validation errors as there shouldn't be any.
#	Perhaps "no column by that name" errors if csv file changes?
#
#	Add successfully_updated value?
#		icf_master_tracker.update_attribute(:sucessfully_updated, successfully_updated)
#	will the above include the line's attributes?
#
#	Add update_errors column?
#		icf_master_tracker.update_attribute(:update_errors, errors)
#

				results.push(icf_master_tracker)

			end	#	(f=FasterCSV.open( self.csv_file.path, 'rb',{ :headers => true })).each
		end	#	if !self.csv_file_file_name.blank? && File.exists?(self.csv_file.path)
		results	#	TODO why am I returning anything?  will I use this later?
	end	#	def parse

end
