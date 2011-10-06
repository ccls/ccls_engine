require 'active_shipping'
#
#	==	named_scopes (don't get parsed by rdoc???)
#	*	delivered
#	*	undelivered
class Package < Shared
	with_options :class_name => 'SampleKit' do |o|
		o.has_one :o_sample_kit, :foreign_key => 'kit_package_id'
		o.has_one :i_sample_kit, :foreign_key => 'sample_package_id'
	end
		
	include ActiveMerchant::Shipping

	has_many	:tracks, :as => :trackable, :dependent => :destroy
	#validates_length_of :tracking_number, :minimum => 3
	validates_uniqueness_of :tracking_number, :allow_blank => true

#	if self.accessible_attributes
#		attr_accessible :tracking_number
#	end

	before_validation :nullify_blank_tracking_number

	def nullify_blank_tracking_number
		#	An empty form field is not NULL to MySQL so ...
		self.tracking_number = nil if tracking_number.blank?
	end

	with_options :maximum => 250, :allow_blank => true do |o|
		o.validates_length_of :status
		o.validates_length_of :tracking_number
		o.validates_length_of :latest_event
	end

	@@fedex = FedEx.new(YAML::load(ERB.new(
		IO.read( File.join(Rails.root,'config/fed_ex.yml') )).result)[::RAILS_ENV])
#		IO.read('config/fed_ex.yml')).result)[::RAILS_ENV])
	cattr_accessor :fedex

	#	Returns the name of the file used to store the
	#	time that the package statuses were last updated 
	#	used by both the app and the background process.
	def self.packages_updated
		"#{RAILS_ROOT}/packages_updated.#{RAILS_ENV}"
	end

	named_scope :delivered, :conditions => {
		:status => 'Delivered'
	}

	named_scope :undelivered, :conditions => [
		'status IS NULL OR status NOT LIKE ?', 'Delivered%'
	]

#	before_create :update_status

	after_save :update_kit_dates

	def sent_on
		if self.tracks.length > 0
			self.tracks.first.time.to_date
		end
	end

	def received_on
		if self.tracks.length > 0 && delivered?
			self.tracks.last.time.to_date
		end
	end

	#	Contact FedEx and get all tracking info regarding
	#	the given package's tracking_number.
	def update_status
		begin
			#	:test => true is NEEDED in test and development
			#	don't know what happens in production
			#	I'm pretty sure that I'll need a "production" key
			#	to remove the :test => true.  I don't know if
			#	the results will be any different.  I doubt it.
			tracking_info = self.class.fedex.find_tracking_info(
				tracking_number, :test => true)

			tracking_info.shipment_events.each do |event|
				#	Added .utc to search as it was not converting
				# on .exists? so would fail on .create!
				unless self.tracks.exists?( :time => event.time.utc )
					self.tracks.create!({
						:time  => event.time,
						:name  => event.name,
						:city  => event.location.city,
						:state => event.location.state,
						:zip   => event.location.zip
					})
				end
			end

			#	All the statuses that I've found (but may be others) ...
			#	Shipment information sent to FedEx
			#	Picked up
			#	Arrived at FedEx location
			#	Departed FedEx location
			#	At local FedEx facility
			#	On FedEx vehicle for delivery
			#	Delivered
			event = tracking_info.latest_event
			status = case event.name
				when 'Delivered' then 'Delivered'
				else 'Transit'
			end
			self.update_attributes({
				:latest_event => "#{event.name} at #{event.location.city}, " <<
					"#{event.location.state} on #{event.time}.",
				:status => status
			})
		rescue
			self.update_attribute(:status, "Update failed")
		end
	end

	#	Loop over all undelivered packages and recheck
	#	and update their status.
	def self.update_undelivered
		self.undelivered.each do |package|
			package.update_status
		end
	end

	#	Returns boolean of whether or not the package 
	#	status suggests that the package was delivered.
	def delivered?
		status =~  /^Delivered/
	end

#
#	I don't really like this, but I needed a way for the background job 
#	to record when it last updated packages statuses so that the views
#	would be able to tell the user.  Creating a database table seemed
#	a bit extreme so I decided to just write it to a file.
#

	#	Read the time contained in the packages_updated file
	#	used by both the app and the background process.
	def self.last_updated
		if File.exists?(packages_updated)
			Time.parse(File.open(packages_updated,'r'){|file| file.read })
		else
			nil
		end
	end

#
#
#	TODO What?  No file locking? I know that there SHOULD only be one
#			app accessing this file, and its not crucial but come on.
#
#

	#	Write the current time to the packages_updated file
	#	used by both the app and the background process.
	def self.just_updated
		File.open(packages_updated,'w'){|file| file.printf Time.now.to_s }
	end

protected

	def update_kit_dates
		if tracks.length > 0
			if    i_sample_kit && i_sample_kit.sample && received_on
				i_sample_kit.sample.update_attribute(
					:received_by_ccls_on,received_on)
			elsif o_sample_kit && o_sample_kit.sample && sent_on
				o_sample_kit.sample.update_attribute(
					:sent_to_subject_on,sent_on)
			end
		end
	end

end
