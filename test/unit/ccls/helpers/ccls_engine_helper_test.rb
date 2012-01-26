require 'test_helper'

class Ccls::HelperTest < ActionView::TestCase

#	user_roles

	test "should respond to user_roles" do
		assert respond_to?(:user_roles)
	end

	test "should get user_roles with superuser login" do
		@user = send(:superuser)
		login_as @user
		@roles = Role.all
		response = HTML::Document.new(user_roles).root
		#	I don't like using super precise matching like this, however,
		expected = %{<ul><li><a href="/users/#{@user.id}/roles/superuser" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'delete'); f.appendChild(m);f.submit();return false;">Remove user role of 'superuser'</a></li>
<li><a href="/users/#{@user.id}/roles/administrator" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'administrator'</a></li>
<li><a href="/users/#{@user.id}/roles/editor" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'editor'</a></li>
<li><a href="/users/#{@user.id}/roles/interviewer" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'interviewer'</a></li>
<li><a href="/users/#{@user.id}/roles/reader" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'reader'</a></li>
</ul>
}
		assert_equal expected, response.to_s
	end

	test "should get user_roles with administrator login" do
		@user = send(:administrator)
		login_as @user
		@roles = Role.all
		response = HTML::Document.new(user_roles).root
		#	I don't like using super precise matching like this, however,
		expected = %{<ul><li><a href="/users/#{@user.id}/roles/superuser" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'superuser'</a></li>
<li><a href="/users/#{@user.id}/roles/administrator" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'delete'); f.appendChild(m);f.submit();return false;">Remove user role of 'administrator'</a></li>
<li><a href="/users/#{@user.id}/roles/editor" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'editor'</a></li>
<li><a href="/users/#{@user.id}/roles/interviewer" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'interviewer'</a></li>
<li><a href="/users/#{@user.id}/roles/reader" onclick="var f = document.createElement('form'); f.style.display = 'none'; this.parentNode.appendChild(f); f.method = 'POST'; f.action = this.href;var m = document.createElement('input'); m.setAttribute('type', 'hidden'); m.setAttribute('name', '_method'); m.setAttribute('value', 'put'); f.appendChild(m);f.submit();return false;">Assign user role of 'reader'</a></li>
</ul>
}
		assert_equal expected, response.to_s
	end

	test "should not get user_roles with interviewer login" do
		@user = send(:interviewer)
		login_as @user
		@roles = Role.all
		response = HTML::Document.new(user_roles).root
		assert response.to_s.blank?
	end

	test "should not get user_roles with editor login" do
		@user = send(:editor)
		login_as @user
		@roles = Role.all
		response = HTML::Document.new(user_roles).root
		assert response.to_s.blank?
	end

	test "should not get user_roles with reader login" do
		@user = send(:reader)
		login_as @user
		@roles = Role.all
		response = HTML::Document.new(user_roles).root
		assert response.to_s.blank?
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

	test "should return div with link to sort column name with order set to name" <<
			" with missing image" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name' }
		self.stubs(:sort_up_image).returns('somefilethatshouldnotexist')
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#		<span class="up arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select '.up.arrow', 1
			assert_select 'span.up.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sortable name sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#	<img class="up arrow" src="/images/sort_up.png?1320424344" alt="Sort_up" /></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select '.up.arrow', 1
			assert_select 'img.up.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'asc' with missing image" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name', :dir => 'asc' }
		self.stubs(:sort_down_image).returns('somefilethatshouldnotexist')
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#		<span class="down arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select '.down.arrow', 1
			assert_select 'span.down.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'asc'" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name', :dir => 'asc' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sortable name sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#	<img class="down arrow" src="/images/sort_down.png?1320424344" alt="Sort_up" /></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select '.down.arrow', 1
			assert_select 'img.down.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'desc' with missing image" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name', :dir => 'desc' }
		self.stubs(:sort_up_image).returns('somefilethatshouldnotexist')
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#		<span class="up arrow">&uarr;</span></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
			assert_select '.up.arrow', 1
			assert_select 'span.up.arrow', 1
		end
	end

	test "should return div with link to sort column name with order set to name" <<
			" and dir set to 'desc'" do
		self.params = { :controller => 'users', :action => 'index', 
			:order => 'name', :dir => 'desc' }
		response = HTML::Document.new(sort_link('name')).root
		#	<div class="sortable name sorted"><a href="/users?dir=asc&amp;order=name">name</a>
		#	<img class="up arrow" src="/images/sort_up.png?1320424344" alt="Sort_up" /></div>
		assert_select response, 'div.sorted', 1 do
			assert_select 'a', 1
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
	def login_as(user)
		@current_user = user
	end
	def current_user	
		@current_user
	end
	def logged_in?
		!current_user.nil?
	end
end
