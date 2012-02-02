class IcfMasterTracker < ActiveRecordShared

	validates_presence_of   :Masterid
	validates_uniqueness_of :Masterid, :allow_blank => true

	belongs_to :study_subject

	before_save :attach_study_subject
	after_save  :update_models

	def attach_study_subject
		unless study_subject_id
			identifier = Identifier.find_by_icf_master_id(self.Masterid)
			if identifier and !identifier.study_subject_id.blank?
				self.study_subject_id = identifier.study_subject_id
			end
		end
	end

	def update_models
#
#	"Masterid","Motherid","Record_Owner","Datereceived","Lastatt","Lastdisp",
#	"Currphone","Vacauthrecd","Recollect","Needpreincentive","Active_Phone",
#	"Recordsentformatching","Recordreceivedfrommatching","Sentpreincentive",
#	"Releasedtocati","Confirmedcaticontact","Refused","Deceasednotification",
#	"Eligible","Confirmationpacketsent","Catiprotocolexhausted",
#	"Newphonenumreleasedtocati","Pleanotificationsent",
#	"Casereturnedtoberkeleyfornewinf","Casereturnedfromberkeley","Caticomplete",
#	"Kitmothersent","Kitinfantsent","Kitchildsent","Kitadolescentsent",
#	"Kitmotherrefusedcode","Kitchildrefusedcode","Noresponsetoplea",
#	"Responsereceivedfromplea","Senttoinpersonfollowup","Kitmotherrecd",
#	"Kitchildrecvd","Thankyousent","Physrequestsent","Physresponsereceived"
#
#	Most of the columns are dates.
#
#		if study_subject_id and dirty
#		Consider Record_Owner field?
#		Which project?
#			add operational event with differences to study subject
#			update models
#		end

		if study_subject_id and self.changed?
#			puts
#			puts "Tracker has subject and has changed so begin updating"
#			puts self.changes
#			which changes matter?
		else
#			puts
#			puts "Tracker has no subject so skipping updating"
		end
	end

end

__END__


changed?() public

Returns true if any attribute have unsaved changes, false otherwise.

person.changed? # => false
person.name = 'bob'
person.changed? # => true


changes() public

Map of changed attrs => [original value, new value].

person.changes # => {}
person.name = 'bob'
person.changes # => { 'name' => ['bill', 'bob'] }


