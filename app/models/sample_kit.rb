# A kit is 2 packages used for retrieving samples.
class SampleKit < ActiveRecordShared

#	add tracking numbers to kit?
#	used to be in packages
#	20120213 - Removing FedEx API, Packages and Tracks.

	belongs_to :sample

	delegate :study_subject, :to => :sample

	validates_uniqueness_of :sample_id, :allow_nil => true

end
