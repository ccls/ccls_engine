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

# needed for wrapped_*_spans and wrapped_*_select
#require 'common_lib/action_view_extension'

class Ccls::ActionViewExtension::FormBuilderTest < ActionView::TestCase

	# needed for wrapped_*_spans and wrapped_*_select
#	include CommonLib::ActionViewExtension::FormBuilder

#	test "y_n_dk_select(method,options={},html_options={})" do
	test "y_n_dk_select" do
		pending	#	TODO
	end

#	test "y_n_o_dk_select(method,options={},html_options={})" do
	test "y_n_o_dk_select" do
		pending	#	TODO
	end

#	test "a_d_na_select(method,options={},html_options={})" do
	test "a_d_na_select" do
		@some_model = SomeModel.new
#	I don't quite get this.  Perhaps trying to call itself??
#  1) Error:
#test_a_d_na_select(Ccls::ActionViewExtension::FormBuilderTest):
#ArgumentError: wrong number of arguments (4 for 3)
#    lib/ccls_engine/action_view_extension/form_builder.rb:26:in `a_d_na_select'
#    lib/ccls_engine/action_view_extension/form_builder.rb:26:in `a_d_na_select'
#    /test/unit/ccls/action_view_extension/form_builder_test.rb:35:in `test_a_d_na_select'
#    /test/unit/ccls/action_view_extension/form_builder_test.rb:35:in `test_a_d_na_select'
#		response = HTML::Document.new(
#			form_for(:some_model,:url => '/'){|f| f.a_d_na_select(:adna) }
#		).root
#		puts response
		pending	#	TODO
	end

end
