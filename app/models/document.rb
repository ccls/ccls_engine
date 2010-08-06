require 'hmac-sha1'
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

#	#	Chronic.parse('tomorrow') is always tomorrow at noon
#	#	so the time between hashing and requesting won't cause
#	#	a problem unless the request is made at exactly the time
#	#	that tomorrow becomes today as far as ruby is concerned.

	def self.s3
		@@s3 ||= YAML::load(ERB.new(IO.read(File.expand_path(
				File.join(File.dirname(__FILE__),'../..','config/s3.yml')
			))).result)[Rails.env]
	end

	def self.s3_access_key_id
		@@s3_access_key_id ||= self.s3['access_key_id']
	end

	def self.s3_secret_access_key
		@@s3_secret_access_key ||= self.s3['secret_access_key']
	end

	def s3_access_key_id
		@s3_access_key_id ||= self.class.s3_access_key_id
	end

	def s3_secret_access_key
		@s3_secret_access_key ||= self.class.s3_secret_access_key
	end

	def s3_expires_on(duration='1 hour from now')
		@s3_expires_on ||= Chronic.parse(duration).to_i.to_s
	end

	#StringToSign = HTTP-VERB + "\n" +
	#    Content-MD5 + "\n" +
	#    Content-Type + "\n" +
	#    Expires + "\n" +
	#    CanonicalizedAmzHeaders +
	#    CanonicalizedResource;    
	def s3_string_to_sign
		@s3_string_to_sign ||= "GET" + "\n" +
			"\n" +
			"\n" +
			s3_expires_on + "\n" +
			"" +
			document.url
#			"/clic/documents/10/bethematch.gif"
	end

	#
	#	http://docs.amazonwebservices.com/AmazonS3/2006-03-01/index.html?RESTAuthentication.html
	#
	#	Signature = URL-Encode( Base64( HMAC-SHA1( 
	#		YourSecretAccessKeyID, UTF-8-Encoding-Of( StringToSign ) ) ) );
	#
	def s3_signature
		#URI.encode(Base64.encode64s(HMAC::SHA1.digest(secret,string_to_sign)))
		#CGI.escape(Base64.encode64s(HMAC::SHA1.digest(secret,string_to_sign)))
		#	URI.encode does NOT encode + or = which doesn't
		#	work for Amazon's S3.  CGI.escape does.
		#	http://redmine.ruby-lang.org/issues/show/1680
		@s3_signature ||= CGI.escape(Base64.encode64s(HMAC::SHA1.digest(
			s3_secret_access_key,s3_string_to_sign)))
	end
	
	def s3_url
#		@s3_url ||= "https://s3.amazonaws.com/clic/documents/10/bethematch.gif?" +
		@s3_url ||= "https://s3.amazonaws.com" +
			document.url + "?" +
			"AWSAccessKeyId=#{s3_access_key_id}&" +
			"Signature=#{s3_signature}&" +
			"Expires=#{s3_expires_on}"
	end

end
