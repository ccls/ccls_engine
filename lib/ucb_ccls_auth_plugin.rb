module UcbCclsAuthPlugin	

	def self.included(base)
		base.extend(PrepMethod)
#		base.send(:include, InstanceMethods)
#		base.class_eval do
#			alias_method_chain :reset_persistence_token, :uniqueness
#		end
	end

	module PrepMethod
		def ucb_authenticated(options={})

			#	We are using UCB CAS for authentication so this is unused.
			#	If Authlogic or other is reused, uncomment all this.
			#
			#	#	by default, expects a username or login attribute
			#	#	which I didn't have and caused a bit of a headache!
			#	#	Also automatically logs newly created user in
			#	#	behind the scenes which caused testing headaches.
			#	#	Set this to false to remove this "feature."
			#	acts_as_authentic do |c|
			#		#	This can be a pain in testing so disabled.
			#		#	Creating objects via Factory with associated users 
			#		#	results in them being autmatically logged in.
			#		c.maintain_sessions = false
			#	end
			#
			#	default_scope :order => :username
			#
			#	validates_length_of :password, :minimum => 8, 
			#		:if => :password_changed?
			#
			#	validates_format_of :password,
			#		:with => Regexp.new(
			#			'(?=.*[a-z])' <<
			#			'(?=.*[A-Z])' <<
			#			'(?=.*\d)' <<
			#			# !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
			#			# '(?=.*[\x21-\x2F\x3A-\x40\x5B-\x60\x7B-\x7E])' 
			#			#	this probably includes control chars
			#			'(?=.*\W)' ), 
			#		:message => 'requires at least one lowercase and one uppercase ' <<
			#			'letter, one number and one special character',
			#		:if => :password_changed?

include UcbCclsAuthPlugin::InstanceMethods
extend  UcbCclsAuthPlugin::ClassMethods


			validates_presence_of   :uid
			validates_uniqueness_of :uid

			has_and_belongs_to_many :roles, :uniq => true

			#	gravatar can't deal with a nil email
			gravatar :mail, :rating => 'PG'

		end
	end

	module ClassMethods

		#	Find or Create a user from a given uid, and then 
		#	proceed to update the user's information from the 
		#	UCB::LDAP::Person.find_by_uid(uid) response.
		#	
		#	Returns: user
		def find_create_and_update_by_uid(uid)
			user = User.find_or_create_by_uid(uid)
			person = UCB::LDAP::Person.find_by_uid(uid) 
			user.update_attributes!({
				:displayname     => person.displayname,
				:sn              => person.sn.first,
				:mail            => person.mail.first || '',
				:telephonenumber => person.telephonenumber.first
			})
			user
		end

		def search(options={})
			conditions = {}
			includes = joins = []
			if !options[:role_name].blank?
				includes = [:roles]
				if Role.all.collect(&:name).include?(options[:role_name])
					joins = [:roles]
					conditions = ["roles.name = '#{options[:role_name]}'"]
		#		else
		#			@errors = "No such role '#{options[:role_name]}'"
				end 
			end 
			User.all( 
				:joins => joins, 
				:include => includes,
				:conditions => conditions )
		end 

	end

	module InstanceMethods

		#	gravatar.url will include & that are not encoded to &amp;
		#	which works just fine, but technically is invalid html.
		def gravatar_url
			gravatar.url.gsub(/&/,'&amp;')
		end

		def role_names
			roles.collect(&:name).uniq
		end

		def deputize
			roles << Role.find_or_create_by_name('administrator')
		end

	protected

	end

end
ActiveRecord::Base.send( :include, UcbCclsAuthPlugin )
