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

class Ccls::ActionViewExtension::FormBuilderTest < ActionView::TestCase

	#	needed for wrapped_*_spans and wrapped_*_select
	include CommonLib::ActionViewExtension::FormBuilder

#	setting template no longer needed as do not have methods in base and form_builder with the same name
		#	form_for(:some_model,@some_model,ActionView::Base.new,:url => '/'){|f| concat f.a_d_na_select(:adna) }
		#	despite form_for accepting template as the third argument, fields_for does not actually use it.
		#		It uses self, which in this case is this test class Ccls::ActionViewExtension::FormBuilderTest
		#		which already has a method named a_d_na_select which causes ...
		#		ArgumentError: wrong number of arguments (4 for 3)
		#	Stubbing does not fix this as it is an instance variable.
#		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
##			f.instance_variable_set('@template',ActionView::Base.new)	#	fake the funk
#			concat f.y_n_dk_select(:yndk) }

	test "y_n_dk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.y_n_dk_select(:yndk) }
		expected = %{<form action="/" method="post"><select id="some_model_yndk" name="some_model[yndk]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don't Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_y_n_dk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_y_n_dk_select(:yndk) }
		expected = %{<form action="/" method="post"><div class='yndk y_n_dk_select field_wrapper'>
<label for="some_model_yndk">Yndk</label><select id="some_model_yndk" name="some_model[yndk]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don't Know</option></select>
</div><!-- class='yndk y_n_dk_select' --></form>}
		assert_equal expected, output_buffer
	end

#	test "y_n_o_dk_select(method,options={},html_options={})" do
	test "y_n_o_dk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.y_n_o_dk_select(:ynodk) }
		expected = %{<form action="/" method="post"><select id="some_model_ynodk" name="some_model[ynodk]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don't Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_y_n_o_dk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_y_n_o_dk_select(:ynodk) }
		expected = %{<form action="/" method="post"><div class='ynodk y_n_o_dk_select field_wrapper'>
<label for="some_model_ynodk">Ynodk</label><select id="some_model_ynodk" name="some_model[ynodk]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don't Know</option></select>
</div><!-- class='ynodk y_n_o_dk_select' --></form>}
		assert_equal expected, output_buffer
	end

#	test "a_d_na_select(method,options={},html_options={})" do
	test "a_d_na_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.a_d_na_select(:adna) }
		expected = %{<form action="/" method="post"><select id="some_model_adna" name="some_model[adna]"><option value=""></option>
<option value="1">Agree</option>
<option value="2">Do Not Agree</option>
<option value="888">N/A</option>
<option value="999">Don't Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_a_d_na_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_a_d_na_select(:adna) }
		expected = %{<form action="/" method="post"><div class='adna a_d_na_select field_wrapper'>
<label for="some_model_adna">Adna</label><select id="some_model_adna" name="some_model[adna]"><option value=""></option>
<option value="1">Agree</option>
<option value="2">Do Not Agree</option>
<option value="888">N/A</option>
<option value="999">Don't Know</option></select>
</div><!-- class='adna a_d_na_select' --></form>}
		assert_equal expected, output_buffer
	end

end
