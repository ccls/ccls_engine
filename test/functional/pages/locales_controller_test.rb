require File.dirname(__FILE__) + '/../../test_helper'

class SimplyPages::LocalesControllerTest < ActionController::TestCase
	tests LocalesController

	test "should set locale to en" do
		assert_nil session[:locale]
		get :show, :id => 'en'
		assert_equal 'en', session[:locale]
		assert_response :redirect
	end

	test "should change locale to es" do
		assert_nil session[:locale]
		session[:locale] = 'en'
		assert_equal 'en', session[:locale]
		get :show, :id => 'es'
		assert_equal 'es', session[:locale]
		assert_response :redirect
	end

	test "should change locale to en" do
		assert_nil session[:locale]
		session[:locale] = 'es'
		assert_equal 'es', session[:locale]
		get :show, :id => 'en'
		assert_equal 'en', session[:locale]
		assert_response :redirect
	end

	test "should set locale to en via js" do
		@request.accept = "text/javascript"
		assert_nil session[:locale]
		get :show, :id => 'en'
		assert_equal 'en', session[:locale]
		assert_response :success
	end

	test "should change locale to es via js" do
		@request.accept = "text/javascript"
		assert_nil session[:locale]
		session[:locale] = 'en'
		assert_equal 'en', session[:locale]
		get :show, :id => 'es'
		assert_equal 'es', session[:locale]
		assert_response :success
	end

	test "should change locale to en via js" do
		@request.accept = "text/javascript"
		assert_nil session[:locale]
		session[:locale] = 'es'
		assert_equal 'es', session[:locale]
		get :show, :id => 'en'
		assert_equal 'en', session[:locale]
		assert_response :success
	end

end
