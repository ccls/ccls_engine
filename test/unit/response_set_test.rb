require File.dirname(__FILE__) + '/../test_helper'

class ResponseSetTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_have_one( :survey_invitation )
	assert_should_have_many( :responses )
	assert_should_belong_to( :user )
	assert_should_initially_belong_to( :survey )
	assert_should_initially_belong_to( :subject )
	assert_should_require_attributes( :survey_id )
	assert_should_require_attributes( :study_subject_id )
	assert_should_not_require_attributes( :user_id )
	assert_should_not_require_attributes( :access_code )
	assert_should_not_require_attributes( :started_at )
	assert_should_not_require_attributes( :completed_at )

#	TODO (maybe)
#	assert_should_require_unique_attributes(:access_code)


	test "should require unique access_code" do
		ResponseSet.stubs(:find_by_access_code).returns(nil)
		rs = create_response_set
		assert_difference( "#{model_name}.count", 0 ) do
			response_set = Factory.build(:response_set)
			assert_not_nil response_set.access_code
			response_set.access_code = rs.access_code
			response_set.save
			assert response_set.errors.on(:access_code)
		end
	end

	test "should require valid subject" do
		assert_difference( "#{model_name}.count", 0 ) do
			object = create_object(:subject => Factory.build(:subject))
			assert object.errors.on(:study_subject_id)
		end
	end 

	test "should replace non unique access_code" do
		rs = create_response_set
		assert_difference( "#{model_name}.count", 1 ) do
			response_set = Factory.build(:response_set)
			assert_not_nil response_set.access_code
			ac1 = response_set.access_code
			response_set.access_code = rs.access_code
			response_set.save
			ac2 = response_set.access_code
			assert_not_equal ac1, ac2
		end
	end

	test "should return codes for response_set" do
		r1 = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'string' },
			:response => { :string_value => "def" }
		)
		r2 = full_response(
			:response => { :response_set => r1.response_set },
			:question => { :data_export_identifier => "ghi" },
			:answer   => { :data_export_identifier => "jkl" }
		)
		assert_equal [["abc","def"],["ghi","jkl"]], 
			r1.response_set.reload.q_and_a_codes
		assert_equal Hash[*[["abc","def"],["ghi","jkl"]].flatten],
			r1.response_set.reload.q_and_a_codes_as_attributes

		assert_equal r1.response_set.reload.codes_and_text,
			Hash['abc'=>{
					:a_code => 'def',
					:a_text => 'def',
					:q_text => r1.question.text
				},
				'ghi'=>{
					:a_code => 'jkl',
					:a_text => Factory.attributes_for(:answer)[:text],
					:q_text => r2.question.text
			}]
	end

	test "should merge matching surveys into single HER" do
		subject = Factory(:subject)
		assert_difference( 'Survey.count', 1 ) {
		assert_difference( 'SurveySection.count', 1 ) {
		assert_difference( 'Question.count', 4 ) {
		assert_difference( 'Answer.count', 4 ) {
		assert_difference( 'ResponseSet.count', 2 ) {
		assert_difference( 'Response.count', 8 ) {
			@rs1 = full_response_set(
				:response_set => { :subject => subject })
			@rs2 = full_response_set(:survey => @rs1.survey,
				:response_set => { :subject => subject })
		} } } } } }

		qa1 = @rs1.reload.q_and_a_codes_as_attributes
		qa2 = @rs2.reload.q_and_a_codes_as_attributes

		assert (@rs1.reload.diff(@rs2.reload)).blank?
		assert @rs1.is_the_same_as?(@rs2)
		assert_equal qa1, qa2
		assert_difference( 'HomeExposureResponse.count') {
			her = @rs1.to_her
			assert_equal subject.id, her.study_subject_id
		}
	end

	test "should destroy responses on set destroy" do
		assert_difference( 'Survey.count', 1 ) {
		assert_difference( 'SurveySection.count', 1 ) {
		assert_difference( 'Question.count', 4 ) {
		assert_difference( 'Answer.count', 4 ) {
		assert_difference( 'ResponseSet.count', 2 ) {
		assert_difference( 'Response.count', 8 ) {
			@rs1 = full_response_set(
				:response_set => { :study_subject_id => 42 })
			@rs2 = full_response_set(:survey => @rs1.survey,
				:response_set => { :study_subject_id => 42 })
		} } } } } }

		assert_difference( 'Survey.count', 0 ) {
		assert_difference( 'SurveySection.count', 0 ) {
		assert_difference( 'Question.count', 0 ) {
		assert_difference( 'Answer.count', 0 ) {
		assert_difference( 'ResponseSet.count', -1 ) {
		assert_difference( 'Response.count', -4 ) {
			@rs1.reload.destroy
		} } } } } }
	end

	test "should convert empty response set to HER" do
		rs = Factory(:response_set)
		assert_difference( 'HomeExposureResponse.count', 1) {
			her = rs.to_her
		}
	end

	test "should compare 2 empty response sets" do
		rs1 = Factory(:response_set)
		rs2 = Factory(:response_set, :survey => rs1.survey )
		assert_not_equal rs1.id, rs2.id
		assert_equal rs1.survey_id, rs2.survey_id
		assert rs1.is_the_same_as?(rs2)
		assert_equal Hash.new, rs1.diff(rs2)
		assert_equal Hash.new, rs1.codes_and_text
	end

end
