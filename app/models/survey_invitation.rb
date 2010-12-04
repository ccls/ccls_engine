# don't know exactly
class SurveyInvitation < Shared
	belongs_to :subject, :foreign_key => 'study_subject_id'
	belongs_to :response_set
	belongs_to :survey

	validates_uniqueness_of :study_subject_id, :scope => :survey_id
	validates_presence_of   :token
	validates_uniqueness_of :token
	validates_presence_of   :response_set_id, :on => :update
	validates_uniqueness_of :response_set_id, :allow_nil => true
	validates_presence_of :study_subject_id
	validates_presence_of :survey_id
	validates_presence_of :subject
	validates_presence_of :survey

	delegate :email, :to => :subject

#	before_validation :create_token
	before_validation_on_create :create_token

protected

	def create_token
#		return unless self.token.blank?
		#	generate random string
		#self.token = Digest::SHA1.hexdigest( 
		#			Time.now.to_s.split(//).sort_by {rand}.join )
		#	128 chars (from rake secret)
		#	activesupport-2.3.5/lib/active_support/secure_random.rb
		begin
			temp_token = ActiveSupport::SecureRandom.hex(64)
		end while SurveyInvitation.exists?(:token => temp_token)
		self.token = temp_token
	end

end
