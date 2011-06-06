# A kit is 2 packages used for retrieving samples.
class SampleKit < Shared
	belongs_to :sample
	belongs_to :kit_package,    :class_name => 'Package'
	belongs_to :sample_package, :class_name => 'Package'

	delegate :subject,     :to => :sample
	delegate :sent_on,     :to => :kit_package
	delegate :received_on, :to => :sample_package

#	validates_uniqueness_of :kit_package_id,  :allow_nil => true
#	validates_uniqueness_of :sample_package_id, :allow_nil => true
	validates_uniqueness_of :sample_id, :allow_nil => true

	accepts_nested_attributes_for :kit_package
	accepts_nested_attributes_for :sample_package

#	after_update :update_sample_dates

#	TODO clean up your room young man

	#	Returns kit shipping status
	def status
		status = case
			when sample_package.status == 'Delivered' then 'Received'
			when sample_package.status == 'Transit' then 'Returned'
			when kit_package.status == 'Delivered' then 'Delivered'
			when kit_package.status == 'Transit' then 'Shipped'
			else 'New'
		end
	end

#Dust Samples are a subclass 
#(generally speaking -- not in the Ruby context) 
#of samples and should be saved in the Samples table. 
#As we discussed last week, Date_Sample_Kit_to_Subject 
#should be the Kit picked up date from CCLS by Fedex. 
#The Date_Sample_Received_CCLS should be the Fedex 
#delivered_on date. I will provide you with the Sample_Type 
#and Sample_Subtypes tables so you can populate the 
#subtype_ID with the correct value for dust samples.

#		def update_sample_dates
#	#		sample.update_attributes({
#	#			:sent_to_subject_on  => sent_on,
#	#			:received_by_ccls_on => received_on
#	#		}) if sample
#			if sample
#				sample.sent_to_subject_on  = sent_on
#				sample.received_by_ccls_on = received_on
#				sample.save
#			end
#		end

end
