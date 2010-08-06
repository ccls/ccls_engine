require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < ActiveSupport::TestCase

	assert_should_require(:title)
	assert_should_belong_to(:owner,:class_name => 'User')

	test "should create document" do
		assert_difference 'Document.count' do
			object = create_object
			assert !object.new_record?, 
				"#{object.errors.full_messages.to_sentence}"
		end
	end

	test "should return class s3_access_key_id" do
		s3_access_key_id = Document.s3_access_key_id
		assert_equal "test_access_key_id", s3_access_key_id
	end

	test "should return class s3_secret_access_key" do
		s3_secret_access_key = Document.s3_secret_access_key
		assert_equal "test_secret_access_key", s3_secret_access_key
	end

	test "should return class s3_protocol" do
		s3_protocol = Document.s3_protocol
		assert_equal "https://", s3_protocol
	end

	test "should return class s3_host" do
		s3_host = Document.s3_host
		assert_equal "s3.amazonaws.com", s3_host
	end

	test "should return s3_access_key_id" do
		object = create_object
		s3_access_key_id = object.s3_access_key_id
		assert_equal "test_access_key_id", s3_access_key_id
	end

	test "should return s3_secret_access_key" do
		object = create_object
		s3_secret_access_key = object.s3_secret_access_key
		assert_equal "test_secret_access_key", s3_secret_access_key
	end

	test "should return s3_expires_on within the hour" do
		object = create_object
		s3_expires_on = object.s3_expires_on
		assert_not_nil s3_expires_on
		printf "Pausing for 3 seconds"
		sleep 5
		assert_equal s3_expires_on, object.s3_expires_on
	end

	test "should return s3_string_to_sign" do
		object = create_object(:document_file_name => "BogusFileName")
		assert_equal object.document.url, 
			"/system/documents/#{object.id}/original/BogusFileName."
		assert_match /\AGET\n\n\n\d+\n\/system\/documents\/\d+\/original\/BogusFileName.\z/, 
			object.s3_string_to_sign
		#puts object.document.url
		#	=> /system/documents/1/original/BogusFileName.
		#puts object.document.path
		#	=> /Users/jake/github_repo/jakewendt/ucb_ccls_engine/test/documents/1/BogusFileName.
	end

	test "should return s3_signature" do
		Document.any_instance.stubs(:s3_string_to_sign).returns(
			"GET\n\n\n1281066749\n/system/documents/1/original/BogusFileName.")
		object = create_object(:document_file_name => "BogusFileName")
		assert_not_nil object.s3_signature
		assert_equal "sZveTMHwpLQk0tA7amx2JNqN7NY%3D", object.s3_signature
		#	=> sZveTMHwpLQk0tA7amx2JNqN7NY%3D
	end

	test "should return s3_path" do
		Document.any_instance.stubs(:s3_expires_on).returns(
			"1281066749")
		Document.any_instance.stubs(:s3_string_to_sign).returns(
			"GET\n\n\n1281066749\n/system/documents/1/original/BogusFileName.")
		object = create_object(:document_file_name => "BogusFileName")
		assert_not_nil object.s3_path
		assert_equal "/system/documents/#{object.id}/original/BogusFileName.?" +
			"AWSAccessKeyId=test_access_key_id&" +
			"Signature=sZveTMHwpLQk0tA7amx2JNqN7NY%3D&Expires=1281066749",
			object.s3_path
	end

	test "should return s3_url" do
		Document.any_instance.stubs(:s3_expires_on).returns(
			"1281066749")
		Document.any_instance.stubs(:s3_string_to_sign).returns(
			"GET\n\n\n1281066749\n/system/documents/1/original/BogusFileName.")
		object = create_object(:document_file_name => "BogusFileName")
		assert_not_nil object.s3_url
		assert_equal "https://s3.amazonaws.com" +
			"/system/documents/#{object.id}/original/BogusFileName.?" +
			"AWSAccessKeyId=test_access_key_id&" +
			"Signature=sZveTMHwpLQk0tA7amx2JNqN7NY%3D&Expires=1281066749",
			object.s3_url
	end

protected

	def create_object(options = {})
		record = Factory.build(:document,options)
		record.save
		record
	end

end
