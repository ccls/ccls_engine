require 'test_helper'

class SomeModel
	attr_accessor :yes_or_no, :int_field
	def initialize(*args,&block)
		yield self if block_given?
	end
	def yes_or_no?
		!!yes_or_no
	end
end

#	needed for wrapped_*_spans and wrapped_*_select
require 'common_lib/action_view_extension'

class Ccls::ActionViewExtension::BaseTest < ActionView::TestCase

	#	needed for wrapped_*_spans and wrapped_*_select
	include CommonLib::ActionViewExtension::Base 

	test "adna(1) should return 'Agree'" do
		assert_equal 'Agree', adna(1)
	end

	test "adna(2) should return 'Do Not Agree'" do
		assert_equal 'Do Not Agree', adna(2)
	end

	test "adna(555) should return 'N/A'" do
		assert_equal "N/A", adna(555)
	end

	test "adna(999) should return 'Don't Know'" do
		assert_equal "Don't Know", adna(999)
	end

	test "adna(0) should return '&nbsp;'" do
		assert_equal "&nbsp;", adna(0)
	end

	test "adna() should return '&nbsp;'" do
		assert_equal "&nbsp;", adna()
	end


	test "yndk(1) should return 'Yes'" do
		assert_equal 'Yes', yndk(1)
	end

	test "yndk(2) should return 'No'" do
		assert_equal 'No', yndk(2)
	end

	test "yndk(3) should return 'Other'" do
		assert_equal 'Other', yndk(3)
	end

	test "yndk(888) should return 'Refused'" do
		assert_equal "Refused", yndk(888)
	end

	test "yndk(999) should return 'Don't Know'" do
		assert_equal "Don't Know", yndk(999)
	end

	test "yndk0() should return '&nbsp;'" do
		assert_equal "&nbsp;", yndk(0)
	end

	test "yndk() should return '&nbsp;'" do
		assert_equal "&nbsp;", yndk()
	end


	test "unwrapped _wrapped_adna_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_adna_spans(:some_model, :int_field)).root
		assert_select response, 'span.label', 'int_field', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_adna_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_adna_spans(:some_model, :int_field)).root
		assert_select response, 'div.int_field.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'int_field', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end


	test "unwrapped _wrapped_yndk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_yndk_spans(:some_model, :int_field)).root
		assert_select response, 'span.label', 'int_field', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_yndk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_yndk_spans(:some_model, :int_field)).root
		assert_select response, 'div.int_field.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'int_field', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

	test "unwrapped _wrapped_ynrdk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_ynrdk_spans(:some_model, :int_field)).root
		assert_select response, 'span.label', 'int_field', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_ynrdk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_ynrdk_spans(:some_model, :int_field)).root
		assert_select response, 'div.int_field.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'int_field', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end


	test "unwrapped _wrapped_ynodk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_ynodk_spans(:some_model, :int_field)).root
		assert_select response, 'span.label', 'int_field', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end


	test "wrapped_ynodk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_ynodk_spans(:some_model, :int_field)).root
		assert_select response, 'div.int_field.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'int_field', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

end
