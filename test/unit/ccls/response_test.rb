require File.dirname(__FILE__) + '/../test_helper'

class ResponseTest < ActiveSupport::TestCase

	assert_should_create_default_object
	assert_should_initially_belong_to( :response_set )
	assert_should_require_attributes( :response_set_id )
	assert_should_require_attributes( :question_id )
	assert_should_require_attributes( :answer_id )
	assert_should_not_require_attributes( :datetime_value )
	assert_should_not_require_attributes( :integer_value )
	assert_should_not_require_attributes( :float_value )
	assert_should_not_require_attributes( :unit )
	assert_should_not_require_attributes( :text_value )
	assert_should_not_require_attributes( :string_value )
	assert_should_not_require_attributes( :response_other )
	assert_should_not_require_attributes( :response_group )


	test "should raise error on q_and_a_codes with invalid response_class" do
		#	This is unlikely to happen in reality
		#	as all of this is part of the gem.
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => '' },
			:response => { :string_value => "xyz" }
		)
		assert_raise(Response::InvalidResponseClass){
			response.q_and_a_codes
		}
	end

	test "should return q_and_a_codes for response_class integer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'integer' },
			:response => { :integer_value => 1942 }
		)
		assert_equal ["abc",1942], response.q_and_a_codes
	end

	test "should return q_and_a_codes for response_class string" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'string' },
			:response => { :string_value => "xyz" }
		)
		assert_equal ["abc","xyz"], response.q_and_a_codes
	end

	test "should return q_and_a_codes for response_class answer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { 
				:data_export_identifier => "xyz",
				:response_class => 'answer' 
			}
		)
		assert_equal ["abc","xyz"], response.q_and_a_codes
	end

	test "should raise error on q_and_a_codes_and_text with invalid response_class" do
		#	This is unlikely to happen in reality
		#	as all of this is part of the gem.
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => '' },
			:response => { :string_value => "xyz" }
		)
		assert_raise(Response::InvalidResponseClass){
			response.q_and_a_codes_and_text
		}
	end

	test "should return q_and_a_codes_and_text for response_class integer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'integer' },
			:response => { :integer_value => 1942 }
		)
		assert_equal response.q_and_a_codes_and_text,
			Hash['abc'=>{:a_code => 1942, :a_text => 1942, 
			:q_text => Factory.attributes_for(:question)[:text]}]
	end

	test "should return q_and_a_codes_and_text for response_class string" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { :response_class => 'string' },
			:response => { :string_value => "xyz" }
		)
		assert_equal response.q_and_a_codes_and_text,
			Hash['abc'=>{:a_code => 'xyz', :a_text => 'xyz', 
			:q_text => Factory.attributes_for(:question)[:text]}]
	end

	test "should return q_and_a_codes_and_text for response_class answer" do
		response = full_response(
			:question => { :data_export_identifier => "abc" },
			:answer   => { 
				:data_export_identifier => "xyz",
				:response_class => 'answer' 
			}
		)
		assert_equal response.q_and_a_codes_and_text,
			Hash['abc'=>{:a_code => 'xyz', 
			:a_text => Factory.attributes_for(:answer)[:text],
			:q_text => Factory.attributes_for(:question)[:text]}]
	end

end
