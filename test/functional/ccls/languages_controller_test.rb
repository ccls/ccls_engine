require 'test_helper'

class Ccls::LanguagesControllerTest < ActionController::TestCase
	tests LanguagesController

	ASSERT_ACCESS_OPTIONS = {
		:model => 'Language',
		:actions => [:new,:create,:edit,:update,:show,:destroy,:index],
		:attributes_for_create => :factory_attributes,
		:method_for_create => :create_language
	}
	def factory_attributes(options={})
		Factory.attributes_for(:language,options)
	end

	assert_access_with_login(    :logins => site_administrators )
	assert_no_access_with_login( :logins => non_site_administrators )
	assert_no_access_without_login
	assert_access_with_https
	assert_no_access_with_http

	assert_no_access_with_login(
		:attributes_for_create => nil,
		:method_for_create => nil,
		:actions => nil,
		:suffix => " and invalid id",
		:login => :superuser,
		:redirect => :languages_path,
		:edit => { :id => 0 },
		:update => { :id => 0 },
		:show => { :id => 0 },
		:destroy => { :id => 0 }
	)

	site_administrators.each do |cu|

		test "should NOT create new language with #{cu} login when create fails" do
			Language.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			assert_difference('Language.count',0) do
				post :create, :language => factory_attributes
			end
			assert assigns(:language)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT create new language with #{cu} login and invalid language" do
			Language.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			assert_difference('Language.count',0) do
				post :create, :language => factory_attributes
			end
			assert assigns(:language)
			assert_response :success
			assert_template 'new'
			assert_not_nil flash[:error]
		end

		test "should NOT update language with #{cu} login when update fails" do
			language = create_language(:updated_at => Chronic.parse('yesterday'))
			Language.any_instance.stubs(:create_or_update).returns(false)
			login_as send(cu)
			deny_changes("Language.find(#{language.id}).updated_at") {
				put :update, :id => language.id,
					:language => factory_attributes
			}
			assert assigns(:language)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

		test "should NOT update language with #{cu} login and invalid language" do
			language = create_language(:updated_at => Chronic.parse('yesterday'))
			Language.any_instance.stubs(:valid?).returns(false)
			login_as send(cu)
			deny_changes("Language.find(#{language.id}).updated_at") {
				put :update, :id => language.id,
					:language => factory_attributes
			}
			assert assigns(:language)
			assert_response :success
			assert_template 'edit'
			assert_not_nil flash[:error]
		end

	end

end
