class IcfMasterTrackerChange < ActiveRecordShared

	#	Would be pointless without the icf_master_id
	validates_presence_of :icf_master_id

#	should probably avoid validations
#	validates_inclusion_of :new_tracker_record, :in => [ true, false ]

end
