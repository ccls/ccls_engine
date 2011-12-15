require 'test_helper'

class SomeModel
	attr_accessor :yes_or_no, :yndk, :ynodk, :adna
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

	test "adna(888) should return 'N/A'" do
		assert_equal "N/A", adna(888)
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

	test "a_d_na(1) should return 'Agree'" do
		assert_equal 'Agree', a_d_na(1)
	end

	test "a_d_na(2) should return 'Do Not Agree'" do
		assert_equal 'Do Not Agree', a_d_na(2)
	end

	test "a_d_na(888) should return 'N/A'" do
		assert_equal "N/A", a_d_na(888)
	end

	test "a_d_na(999) should return 'Don't Know'" do
		assert_equal "Don't Know", a_d_na(999)
	end

	test "a_d_na(0) should return '&nbsp;'" do
		assert_equal "&nbsp;", a_d_na(0)
	end

	test "a_d_na() should return '&nbsp;'" do
		assert_equal "&nbsp;", a_d_na()
	end

	test "yndk(1) should return 'Yes'" do
		assert_equal 'Yes', yndk(1)
	end

	test "yndk(2) should return 'No'" do
		assert_equal 'No', yndk(2)
	end

	test "yndk(999) should return 'Don't Know'" do
		assert_equal "Don't Know", yndk(999)
	end

	test "yndk(0) should return '&nbsp;'" do
		assert_equal "&nbsp;", yndk(0)
	end

	test "yndk() should return '&nbsp;'" do
		assert_equal "&nbsp;", yndk()
	end

	test "y_n_dk(1) should return 'Yes'" do
		assert_equal 'Yes', y_n_dk(1)
	end

	test "y_n_dk(2) should return 'No'" do
		assert_equal 'No', y_n_dk(2)
	end

	test "y_n_dk(999) should return 'Don't Know'" do
		assert_equal "Don't Know", y_n_dk(999)
	end

	test "y_n_dk(0) should return '&nbsp;'" do
		assert_equal "&nbsp;", y_n_dk(0)
	end

	test "y_n_dk() should return '&nbsp;'" do
		assert_equal "&nbsp;", y_n_dk()
	end

	test "ynodk(1) should return 'Yes'" do
		assert_equal 'Yes', ynodk(1)
	end

	test "ynodk(2) should return 'No'" do
		assert_equal 'No', ynodk(2)
	end

	test "ynodk(3) should return 'Other'" do
		assert_equal 'Other', ynodk(3)
	end

	test "ynodk(999) should return 'Don't Know'" do
		assert_equal "Don't Know", ynodk(999)
	end

	test "ynodk(0) should return '&nbsp;'" do
		assert_equal "&nbsp;", ynodk(0)
	end

	test "ynodk() should return '&nbsp;'" do
		assert_equal "&nbsp;", ynodk()
	end

	test "y_n_o_dk(1) should return 'Yes'" do
		assert_equal 'Yes', y_n_o_dk(1)
	end

	test "y_n_o_dk(2) should return 'No'" do
		assert_equal 'No', y_n_o_dk(2)
	end

	test "y_n_o_dk(3) should return 'Other'" do
		assert_equal 'Other', y_n_o_dk(3)
	end

	test "y_n_o_dk(999) should return 'Don't Know'" do
		assert_equal "Don't Know", y_n_o_dk(999)
	end

	test "y_n_o_dk(0) should return '&nbsp;'" do
		assert_equal "&nbsp;", y_n_o_dk(0)
	end

	test "y_n_o_dk() should return '&nbsp;'" do
		assert_equal "&nbsp;", y_n_o_dk()
	end

	test "unwrapped _wrapped_adna_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_adna_spans(:some_model, :adna)).root
		assert_select response, 'span.label', 'adna', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_adna_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_adna_spans(:some_model, :adna)).root
		assert_select response, 'div.adna.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'adna', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

	test "unwrapped _wrapped_a_d_na_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_a_d_na_spans(:some_model, :adna)).root
		assert_select response, 'span.label', 'adna', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_a_d_na_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_a_d_na_spans(:some_model, :adna)).root
		assert_select response, 'div.adna.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'adna', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

	test "unwrapped _wrapped_yndk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_yndk_spans(:some_model, :yndk)).root
		assert_select response, 'span.label', 'yndk', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_yndk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_yndk_spans(:some_model, :yndk)).root
		assert_select response, 'div.yndk.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'yndk', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

	test "unwrapped _wrapped_y_n_dk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_y_n_dk_spans(:some_model, :yndk)).root
		assert_select response, 'span.label', 'yndk', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_y_n_dk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_y_n_dk_spans(:some_model, :yndk)).root
		assert_select response, 'div.yndk.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'yndk', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

	test "unwrapped _wrapped_ynodk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_ynodk_spans(:some_model, :ynodk)).root
		assert_select response, 'span.label', 'ynodk', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_ynodk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_ynodk_spans(:some_model, :ynodk)).root
		assert_select response, 'div.ynodk.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'ynodk', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

	test "unwrapped _wrapped_y_n_o_dk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			_wrapped_y_n_o_dk_spans(:some_model, :ynodk)).root
		assert_select response, 'span.label', 'ynodk', 1
		assert_select response, 'span.value', '&nbsp;', 1
	end

	test "wrapped_y_n_o_dk_spans" do
		@some_model = SomeModel.new
		response = HTML::Document.new(
			wrapped_y_n_o_dk_spans(:some_model, :ynodk)).root
		assert_select response, 'div.ynodk.field_wrapper', 1 do
			assert_select 'label', 0
			assert_select 'span.label', 'ynodk', 1
			assert_select 'span.value', '&nbsp;', 1
		end
	end

#	test "wrapped_adna_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			wrapped_adna_select(:some_model, :adna)).root
#		assert_select response, 'div.adna.field_wrapper', 1 do
#			assert_select 'label[for=some_model_adna]','Adna',1 
#			assert_select response, "select#some_model_adna[name='some_model[adna]']" do
#				assert_select 'option[value=1]', 'Agree'
#				assert_select 'option[value=2]', 'Do Not Agree'
#				assert_select 'option[value=888]', "N/A"
#				assert_select 'option[value=999]', "Don't Know"
#			end
#		end
#	end
#
#	test "wrapped_a_d_na_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			wrapped_a_d_na_select(:some_model, :adna)).root
#		assert_select response, 'div.adna.field_wrapper', 1 do
#			assert_select 'label[for=some_model_adna]','Adna',1 
#			assert_select response, "select#some_model_adna[name='some_model[adna]']" do
#				assert_select 'option[value=1]', 'Agree'
#				assert_select 'option[value=2]', 'Do Not Agree'
#				assert_select 'option[value=888]', "N/A"
#				assert_select 'option[value=999]', "Don't Know"
#			end
#		end
#	end
#
#	test "wrapped_y_n_dk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			wrapped_y_n_dk_select(:some_model, :yndk)).root
#		assert_select response, 'div.yndk.field_wrapper', 1 do
#			assert_select 'label[for=some_model_yndk]','Yndk',1 
#			assert_select "select#some_model_yndk[name='some_model[yndk]']" do
#				assert_select 'option[value=1]', 'Yes'
#				assert_select 'option[value=2]', 'No'
#				assert_select 'option[value=999]', "Don't Know"
#			end
#		end
#	end
#
#	test "wrapped_yndk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			wrapped_yndk_select(:some_model, :yndk)).root
#		assert_select response, 'div.yndk.field_wrapper', 1 do
#			assert_select 'label[for=some_model_yndk]','Yndk',1 
#			assert_select "select#some_model_yndk[name='some_model[yndk]']" do
#				assert_select 'option[value=1]', 'Yes'
#				assert_select 'option[value=2]', 'No'
#				assert_select 'option[value=999]', "Don't Know"
#			end
#		end
#	end
#
#	test "wrapped_y_n_o_dk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			wrapped_y_n_o_dk_select(:some_model, :ynodk)).root
#		assert_select response, 'div.ynodk.field_wrapper', 1 do
#			assert_select 'label[for=some_model_ynodk]','Ynodk',1 
#			assert_select response, "select#some_model_ynodk[name='some_model[ynodk]']" do
#				assert_select 'option[value=1]', 'Yes'
#				assert_select 'option[value=2]', 'No'
#				assert_select 'option[value=3]', 'Other'
#				assert_select 'option[value=999]', "Don't Know"
#			end
#		end
#	end
#
#	test "wrapped_ynodk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			wrapped_ynodk_select(:some_model, :ynodk)).root
#		assert_select response, 'div.ynodk.field_wrapper', 1 do
#			assert_select 'label[for=some_model_ynodk]','Ynodk',1 
#			assert_select response, "select#some_model_ynodk[name='some_model[ynodk]']" do
#				assert_select 'option[value=1]', 'Yes'
#				assert_select 'option[value=2]', 'No'
#				assert_select 'option[value=3]', 'Other'
#				assert_select 'option[value=999]', "Don't Know"
#			end
#		end
#	end
#
#	test "a_d_na_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			a_d_na_select(:some_model, :adna)).root
#		assert_select response, "select#some_model_adna[name='some_model[adna]']" do
#			assert_select 'option[value=1]', 'Agree'
#			assert_select 'option[value=2]', 'Do Not Agree'
#			assert_select 'option[value=888]', "N/A"
#			assert_select 'option[value=999]', "Don't Know"
#		end
#	end
#
#	test "adna_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			adna_select(:some_model, :adna)).root
#		assert_select response, "select#some_model_adna[name='some_model[adna]']" do
#			assert_select 'option[value=1]', 'Agree'
#			assert_select 'option[value=2]', 'Do Not Agree'
#			assert_select 'option[value=888]', "N/A"
#			assert_select 'option[value=999]', "Don't Know"
#		end
#	end
#
#	test "y_n_dk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			y_n_dk_select(:some_model, :yndk)).root
#		assert_select response, "select#some_model_yndk[name='some_model[yndk]']" do
#			assert_select 'option[value=1]', 'Yes'
#			assert_select 'option[value=2]', 'No'
#			assert_select 'option[value=999]', "Don't Know"
#		end
#	end
#
#	test "yndk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			yndk_select(:some_model, :yndk)).root
#		assert_select response,"select#some_model_yndk[name='some_model[yndk]']" do
#			assert_select 'option[value=1]', 'Yes'
#			assert_select 'option[value=2]', 'No'
#			assert_select 'option[value=999]', "Don't Know"
#		end
#	end
#
#	test "y_n_o_dk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			y_n_o_dk_select(:some_model, :ynodk)).root
#		assert_select response, "select#some_model_ynodk[name='some_model[ynodk]']" do
#			assert_select 'option[value=1]', 'Yes'
#			assert_select 'option[value=2]', 'No'
#			assert_select 'option[value=3]', 'Other'
#			assert_select 'option[value=999]', "Don't Know"
#		end
#	end
#
#	test "ynodk_select" do
#		@some_model = SomeModel.new
#		response = HTML::Document.new(
#			ynodk_select(:some_model, :ynodk)).root
#		assert_select response,"select#some_model_ynodk[name='some_model[ynodk]']" do
#			assert_select 'option[value=1]', 'Yes'
#			assert_select 'option[value=2]', 'No'
#			assert_select 'option[value=3]', 'Other'
#			assert_select 'option[value=999]', "Don't Know"
#		end
#	end

end