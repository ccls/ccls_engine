class UserInvitation < ActiveRecord::Base
	belongs_to :sender, :class_name => 'User'
	belongs_to :recipient, :class_name => 'User'

	validates_presence_of :sender_id, :sender
	validates_presence_of :email
#	validates_format_of   :email, :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	validates_presence_of   :token
	validates_uniqueness_of :token

	before_validation_on_create :generate_unique_token

	attr_accessible :email, :message

protected

	def generate_unique_token
#		return unless self.token.blank?
		#  generate random string
		#  self.token = Digest::SHA1.hexdigest( 
		#    Time.now.to_s.split(//).sort_by {rand}.join )
		#  128 chars (from rake secret)
		#  activesupport-2.3.5/lib/active_support/secure_random.rb
		begin
			temp_token = ActiveSupport::SecureRandom.hex(64)
		end while UserInvitation.exists?(:token => temp_token)
		self.token = temp_token
	end

end
