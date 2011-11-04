require 'test_helper'

class Ccls::HelperTest < ActionView::TestCase

#	user_roles

	test "should respond to user_roles" do
		assert respond_to?(:user_roles)
	end

#	sort_link

	test "should respond to sort_link" do
		assert respond_to?(:sort_link)
	end

	test "should return div with link to sort column name" do
		#	NEED controller and action as method calls link_to which requires them
		self.params = { :controller => 'users', :action => 'index' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class=""><a href="/users?dir=asc&amp;order=name">name</a></div>
		assert_select response, 'div', 1 do
			assert_select 'a', 1
			assert_select 'span', 0
		end
	end

	test "should return div with link to sort column name with order set to name" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#		<span class="up arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
#			assert_select 'span.up.arrow', 1
#	Using images now
			assert_select '.up.arrow', 1
			assert_select 'img.up.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'asc'" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name', :dir => 'asc' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#		<span class="down arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
#			assert_select 'span.down.arrow', 1
#	Using images now
			assert_select '.down.arrow', 1
			assert_select 'img.down.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'desc'" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name', :dir => 'desc' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#		<span class="up arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
#			assert_select 'span.up.arrow', 1
#	Using images now
			assert_select '.up.arrow', 1
			assert_select 'img.up.arrow', 1
		end
	end

#	subject_id_bar

	test "should respond to subject_id_bar" do
		assert respond_to?(:subject_id_bar)
	end

	test "should respond to study_subject_id_bar" do
		assert respond_to?(:study_subject_id_bar)
	end

	test "subject_id_bar should return subject_id_bar" do
		subject = create_study_subject
		assert subject.is_a?(StudySubject)
		assert !subject.do_not_contact?
		assert_nil subject_id_bar(subject)	#	sets content_for :main
		response = HTML::Document.new(@content_for_main).root
		assert_select response, 'div#id_bar' do
			assert_select 'div.childid'
			assert_select 'div.studyid'
			assert_select 'div.full_name'
			assert_select 'div.controls'
		end
		assert_select response, 'div#do_not_contact', 0
	end

	test "subject_id_bar should return subject_id_bar with do not contact" do
		subject = create_study_subject(:do_not_contact => true)
		assert subject.is_a?(StudySubject)
		assert subject.do_not_contact?
		assert_nil subject_id_bar(subject)	#	sets content_for :main
		response = HTML::Document.new(@content_for_main).root
		assert_select response, 'div#id_bar' do
			assert_select 'div.childid'
			assert_select 'div.studyid'
			assert_select 'div.full_name'
			assert_select 'div.controls'
		end
		assert_select response, 'div#do_not_contact'
	end

#	required

	test "required(text) should" do
		response = HTML::Document.new(required('something')).root
		#"<span class='required'>something</span>"
		assert_select response, 'span.required', 'something', 1
	end

#	req

	test "req(text) should" do
		response = HTML::Document.new(req('something')).root
		#"<span class='required'>something</span>"
		assert_select response, 'span.required', 'something', 1
	end

private 
	def params
		@params || {}
	end
	def params=(new_params)
		@params = new_params
	end
	def stylesheets(*args)
		#	placeholder so can call subject_id_bar and avoid
		#		NoMethodError: undefined method `stylesheets' for #<Ccls::HelperTest:0x109e8ef90>
	end
end
