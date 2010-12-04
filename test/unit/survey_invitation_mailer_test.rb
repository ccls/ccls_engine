require File.dirname(__FILE__) + '/../test_helper'

class SurveyInvitationMailerTest < ActionMailer::TestCase

	setup :build_stuff
	def build_stuff
		@survey  = Factory(:survey)
		@subject = Factory(:subject, 
			:pii_attributes => Factory.attributes_for(:pii))
		@si      = Factory(:survey_invitation, {
			:survey_id => @survey.id,
			:subject => @subject
		})
	end

	test "should create invitation" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			mail = SurveyInvitationMailer.create_invitation(@si)
			assert_match "@example.com", mail.to.first
		}
		assert_nil @si.sent_at
	end

	test "should deliver invitation" do
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			mail = SurveyInvitationMailer.deliver_invitation(@si)
			assert_match "@example.com", mail.to.first
		}
		assert_not_nil @si.sent_at
	end

	test "should NOT deliver invitation without email" do
		@si.subject.pii.update_attribute(:email, nil)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_raise(SurveyInvitationMailer::NoEmailAddress){
			SurveyInvitationMailer.deliver_invitation(@si)
		} }
		assert_nil @si.sent_at
	end

	test "should create reminder" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			mail = SurveyInvitationMailer.create_reminder(@si)
			assert_match "@example.com", mail.to.first
		}
	end

	test "should deliver reminder" do
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			mail = SurveyInvitationMailer.deliver_reminder(@si)
			assert_match "@example.com", mail.to.first
		}
	end

	test "should NOT deliver reminder without email" do
		@si.subject.pii.update_attribute(:email, nil)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_raise(SurveyInvitationMailer::NoEmailAddress){
			SurveyInvitationMailer.deliver_reminder(@si)
		} }
	end

	test "should create thank_you" do
		assert_difference('ActionMailer::Base.deliveries.length',0) {
			mail = SurveyInvitationMailer.create_thank_you(@si)
			assert_match "@example.com", mail.to.first
		}
	end

	test "should deliver thank_you" do
		assert_difference('ActionMailer::Base.deliveries.length',1) {
			mail = SurveyInvitationMailer.deliver_thank_you(@si)
			assert_match "@example.com", mail.to.first
		}
	end

	test "should NOT deliver thank_you without email" do
		@si.subject.pii.update_attribute(:email, nil)
		assert_difference('ActionMailer::Base.deliveries.length',0) {
		assert_raise(SurveyInvitationMailer::NoEmailAddress){
			SurveyInvitationMailer.deliver_thank_you(@si)
		} }
	end

end
