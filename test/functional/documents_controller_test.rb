require File.dirname(__FILE__) + '/../test_helper'

class DocumentsControllerTest < ActionController::TestCase

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Document',
		:actions => [:new,:create,:edit,:update,:destroy,:show,:index],
		:method_for_create => :factory_create,
		:attributes_for_create => :factory_attributes
	}

	def factory_create
		Factory(:document)
	end
	def factory_attributes
		Factory.attributes_for(:document)
	end

	assert_access_with_https
	assert_access_with_login({
		:logins => [:admin,:editor]})

	assert_no_access_with_http 
	assert_no_access_with_login({ 
		:logins => [:moderator,:employee,:active_user] })
	assert_no_access_without_login

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :admin,
		:redirect => :documents_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:destroy => { :id => 0 }
	)

%w( admin editor ).each do |cu|

	test "should NOT download document with no document and #{cu} login" do
		document = Factory(:document)
		login_as send(cu)
		get :download, :id => document.id
		assert_redirected_to document
		assert_not_nil flash[:error]
#		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*pdf/)
	end

	test "should download document with document and #{cu} login" do
		document = Factory(:document, :document => 'README.rdoc')
		login_as send(cu)
		get :download, :id => document.id
#		assert_redirected_to document
#		assert_not_nil flash[:error]
#		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*pdf/)
		pending
	end

	test "should NOT create invalid document with #{cu} login" do
		login_as send(cu)
		assert_no_difference('Document.count') do
			post :create, :document => {}
		end
		assert_not_nil flash[:error]
		assert_template 'new'
		assert_response :success
	end

	test "should NOT update invalid document with #{cu} login" do
		login_as send(cu)
		put :update, :id => Factory(:document).id, 
			:document => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

end

%w( moderator employee active_user ).each do |cu|

	test "should NOT download document with #{cu} login" do
		document = Factory(:document)
		login_as send(cu)
		get :download, :id => document.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
#		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*pdf/)
	end

end

	test "should NOT download document without login" do
		document = Factory(:document)
		get :download, :id => document.id
		assert_redirected_to_login
	end

end
