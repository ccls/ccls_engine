require 'hmac-sha1'
require 'base64'
class Document < ActiveRecord::Base
	belongs_to :owner, :class_name => 'User'
#	has_and_belongs_to_many :users
#	has_and_belongs_to_many :groups

	validates_presence_of :title
	validates_length_of :title, :minimum => 4

	validates_uniqueness_of :document_file_name, :allow_nil => true

	before_validation :nullify_blank_document_file_name

	has_attached_file :document,
		YAML::load(ERB.new(IO.read(File.expand_path(
			File.join(File.dirname(__FILE__),'../..','config/document.yml')
		))).result)[Rails.env]

	def nullify_blank_document_file_name
		self.document_file_name = nil if document_file_name.blank?
	end

#
#	http://docs.amazonwebservices.com/AmazonS3/2006-03-01/index.html?RESTAuthentication.html
#
#Signature = URL-Encode( Base64( HMAC-SHA1( YourSecretAccessKeyID, UTF-8-Encoding-Of( StringToSign ) ) ) );
#
#StringToSign = HTTP-VERB + "\n" +
#    Content-MD5 + "\n" +
#    Content-Type + "\n" +
#    Expires + "\n" +
#    CanonicalizedAmzHeaders +
#    CanonicalizedResource;    
	def string_to_sign
		"GET" + "\n" +
		"\n" +
		"\n" +
		Chronic.parse('tomorrow').to_i.to_s + "\n" +
		"" +
		"/clic/documents/10/bethematch.gif"
	end

	def signature
		s3 = YAML::load(IO.read('config/s3.yml'))
		secret = s3['secret_access_key']
#URI.encode(Base64.encode64s(HMAC::SHA1.digest(secret,string_to_sign)))
#CGI.escape(Base64.encode64s(HMAC::SHA1.digest(secret,string_to_sign)))
		#	URI.encode does NOT encode + or = which doesn't
		#	work for Amazon's S3.  CGI.escape does.
		#	http://redmine.ruby-lang.org/issues/show/1680
		CGI.escape(Base64.encode64s(HMAC::SHA1.digest(secret,string_to_sign)))
	end

	def s3_url
		s3 = YAML::load(IO.read('config/s3.yml'))
		access_key_id = s3['access_key_id']
		"https://s3.amazonaws.com/clic/documents/10/bethematch.gif?" +
			"AWSAccessKeyId=#{access_key_id}&" +
			"Signature=#{signature}&" +
			"Expires=#{Chronic.parse('tomorrow').to_i}"
	end

#	Chronic.parse('tomorrow') is always tomorrow at noon
#	so the time between hashing and requesting won't cause
#	a problem unless the request is made at exactly the time
#	that tomorrow becomes today as far as ruby is concerned.

end
