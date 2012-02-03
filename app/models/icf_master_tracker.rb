class IcfMasterTracker < ActiveRecordShared

	validates_presence_of   :Masterid
	validates_uniqueness_of :Masterid, :allow_blank => true

	belongs_to :study_subject

	before_save :attach_study_subject

	#	This may not be the best way to update.
	#	We may have to implement something like BackgrounDRb.
	#	Updating the actual data may require a number of SQL searches
	#	to find the appropriate columns which could consume enough
	#	time to trigger a timeout. In addition, there may not be
	#	enough information here to determine the correct model
	#	to update, but we'll see how it progresses.
	#	If we do use BackgrounDRb, we'll probably need an additional
	#	column to flag has having been updated to be set in
	#	a before_save callback.  This would then need unset by
	#	the BackgrounDRb worker when complete.
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
#	Most of the columns are dates which probably correspond to an enrollment or sample.
#Table: samples
#+------------------------------+---------------
#| Field                        | Type         
#+------------------------------+--------------
#| aliquot_sample_format_id     | int(11)      
#| sample_type_id               | int(11)      
#| study_subject_id             | int(11)      
#| unit_id                      | int(11)      
#| order_no                     | int(11)      
#| quantity_in_sample           | decimal(10,0)
#| aliquot_or_sample_on_receipt | varchar(255) 
#| sent_to_subject_on           | date         
#| received_by_ccls_on          | date        
#| sent_to_lab_on               | date        
#| received_by_lab_on           | date        
#| aliquotted_on                | date        
#| external_id                  | varchar(255)
#| external_id_source           | varchar(255)
#| receipt_confirmed_on         | date        
#| receipt_confirmed_by         | varchar(255)
#| future_use_prohibited        | tinyint(1)  
#| collected_on                 | date       
#| location_id                  | int(11)   
#
#		if study_subject_id and dirty
#		Consider Record_Owner field?
#		Which project?
#			add operational event with differences to study subject
#			update models
#		end

		if study_subject_id and changed?
#			puts
#			puts "Tracker has subject and has changed so begin updating"
#			puts self.changes
#
#			Which changes matter?
#			There are many validations, so what to do if update fails?
#			If subject doesn't initially exist (shouldn't happen),
#				then these updates will NEVER be added as the record
#				"changes" won't be changed.  Will need another condition
#				to update everything if study_subject_id is new.
#				Again, this shouldn't actually ever happen as the Masterid
#				is assigned to a subject by us, meaning the subject exists
#				before giving it to ICF.

			ignore = %w{id study_subject_id Masterid created_at updated_at}
			unignored_changes = changes.dup.delete_keys!(*ignore)
			unless unignored_changes.empty?
#				description = []
#				unignored_changes.each { |field,values|
#					description << "#{field} changed from #{values[0]} to #{values[1]}"
#				}
				OperationalEvent.create!(
					:enrollment => study_subject.enrollments.find_or_create_by_project_id(
						Project[:ccls].id),
					:operational_event_type => OperationalEventType[:other],
#
#	description can only be 250 chars so this fails in testing
#		when creating new tracker as everything has changed.
#	Change description to text?  Will 65000 chars be enough?
#
#					:description => description.join("\n")
					:description => "Icf Master Tracker caused changes."
				)
			end
#		else
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


