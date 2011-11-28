require 'test_helper'

class FakeUser
	attr_accessor :yes_or_no, :yndk
	def initialize(*args,&block)
		yield self if block_given?
	end
	def yes_or_no?
		!!yes_or_no
	end
end

class Ccls::ActionViewExtension::BaseTest < ActionView::TestCase

	test "wrapped_y_n_dk_select" do
#		@user = Ccls::User.new
		@user = FakeUser.new
		response = HTML::Document.new(
			wrapped_y_n_dk_select(:user, :yndk)).root
#<div class="yndk field_wrapper">
#<label for="user_yndk">Yndk</label><select id="user_yndk" name="user[yndk]"><option value="1">Yes</option>
#<option value="2">No</option>
#<option value="999">Don't Know</option></select>
#</div><!-- class='yndk' -->
		assert_select response, 'div.yndk.field_wrapper', 1 do
			assert_select 'label[for=user_yndk]','Yndk',1 
			assert_select "select#user_yndk[name='user[yndk]']" do
				assert_select 'option[value=1]', 'Yes'
				assert_select 'option[value=2]', 'No'
				assert_select 'option[value=999]', "Don't Know"
			end
		end
	end

	test "wrapped_yndk_select" do
#		@user = Ccls::User.new
		@user = FakeUser.new
		response = HTML::Document.new(
			wrapped_yndk_select(:user, :yndk)).root
#<div class="yndk field_wrapper">
#<label for="user_yndk">Yndk</label><select id="user_yndk" name="user[yndk]"><option value="1">Yes</option>
#<option value="2">No</option>
#<option value="999">Don't Know</option></select>
#</div><!-- class='yndk' -->
		assert_select response, 'div.yndk.field_wrapper', 1 do
			assert_select 'label[for=user_yndk]','Yndk',1 
			assert_select "select#user_yndk[name='user[yndk]']" do
				assert_select 'option[value=1]', 'Yes'
				assert_select 'option[value=2]', 'No'
				assert_select 'option[value=999]', "Don't Know"
			end
		end
	end

end
