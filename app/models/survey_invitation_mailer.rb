# don't know exactly
class SurveyInvitationMailer < ActionMailer::Base

#
#	No callbacks????
#
#	Would be nice to be able to do something like ...
#
#	before_deliver :ensure_valid_email_address
#

	class NoEmailAddress < StandardError	#	:nodoc:
	end

	def invitation(survey_invitation)
		subject    'CCLS Survey Invitation'
		recipients survey_invitation.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

	def reminder(survey_invitation)
		subject    'CCLS Survey Reminder'
		recipients survey_invitation.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

	def thank_you(survey_invitation)
		subject    'CCLS Survey Thank You'
		recipients survey_invitation.email
		body       :greeting => 'Hi,'
		body       :invitation => survey_invitation
	end

#
#	The following is exactly the same as in UserMailer
#	Perhaps should make this a plugin or just a lib.
#

protected

	#	Simple way of enforcing the presence of a recipient.
	#	This does NOT ensure that it is valid, just not empty.
	def deliver_with_required_email!(mail = @mail)
		raise NoEmailAddress if mail.to.blank?
		deliver_without_required_email!(mail)
	end
	alias_method_chain :deliver!, :required_email

	#	After successful delivery, add timestamp to invitation.
	def deliver_with_timestamp!(mail=@mail)
		returned_mail = deliver_without_timestamp!(mail)
		if self.action_name == 'invitation'
			self.parameters.first.update_attribute(:sent_at, Time.now)
		end
		returned_mail
	end
	alias_method_chain :deliver!, :timestamp

	#	The invitation gets lost in the mail, so to speak.
	#	We need to remember the parameters so that we can
	#	update the sent_at attribute.
	def initialize_with_memory(method_name=nil, *parameters)
		self.parameters = parameters
		initialize_without_memory(method_name,*parameters)
	end
	alias_method_chain :initialize, :memory

	#	The aptly named virtual attibute for storing 
	#	the parameters passed to the mailer.
	attr_accessor :parameters

end
