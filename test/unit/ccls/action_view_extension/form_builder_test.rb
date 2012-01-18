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

class Ccls::ActionViewExtension::FormBuilderTest < ActionView::TestCase

	#	needed for field_wrapper
	include CommonLib::ActionViewExtension::Base
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

	test "yndk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.yndk_select(:int_field) }
		expected = %{<form action="/" method="post"><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don't Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_yndk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_yndk_select(:int_field) }
		expected = %{<form action="/" method="post"><div class='int_field yndk_select field_wrapper'>
<label for="some_model_int_field">Int field</label><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don't Know</option></select>
</div><!-- class='int_field yndk_select' --></form>}
		assert_equal expected, output_buffer
	end


	test "ynrdk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.ynrdk_select(:int_field) }
		expected = %{<form action="/" method="post"><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don't Know</option>
<option value="0">Refused</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_ynrdk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_ynrdk_select(:int_field) }
		expected = %{<form action="/" method="post"><div class='int_field ynrdk_select field_wrapper'>
<label for="some_model_int_field">Int field</label><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="999">Don't Know</option>
<option value="0">Refused</option></select>
</div><!-- class='int_field ynrdk_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "ynodk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.ynodk_select(:int_field) }
		expected = %{<form action="/" method="post"><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don't Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_ynodk_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_ynodk_select(:int_field) }
		expected = %{<form action="/" method="post"><div class='int_field ynodk_select field_wrapper'>
<label for="some_model_int_field">Int field</label><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Yes</option>
<option value="2">No</option>
<option value="3">Other</option>
<option value="999">Don't Know</option></select>
</div><!-- class='int_field ynodk_select' --></form>}
		assert_equal expected, output_buffer
	end

	test "adna_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.adna_select(:int_field) }
		expected = %{<form action="/" method="post"><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Agree</option>
<option value="2">Do Not Agree</option>
<option value="888">N/A</option>
<option value="999">Don't Know</option></select></form>}
		assert_equal expected, output_buffer
	end

	test "wrapped_adna_select" do
		form_for(:some_model,SomeModel.new,:url => '/'){|f| 
			concat f.wrapped_adna_select(:int_field) }
		expected = %{<form action="/" method="post"><div class='int_field adna_select field_wrapper'>
<label for="some_model_int_field">Int field</label><select id="some_model_int_field" name="some_model[int_field]"><option value=""></option>
<option value="1">Agree</option>
<option value="2">Do Not Agree</option>
<option value="888">N/A</option>
<option value="999">Don't Know</option></select>
</div><!-- class='int_field adna_select' --></form>}
		assert_equal expected, output_buffer
	end

end
