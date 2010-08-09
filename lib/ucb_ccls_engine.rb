module Ccls
module UcbCclsEngine

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

			include UcbCclsEngine::InstanceMethods
			extend  UcbCclsEngine::ClassMethods

			validates_presence_of   :uid
			validates_uniqueness_of :uid

			has_and_belongs_to_many :roles,  :uniq => true
#
#	Don't do this until Group is defined!!!
#
#			has_and_belongs_to_many :groups, :uniq => true

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

		def may_administrate?(*args)
			self.role_names.include?('administrator')
		end
		alias_method :may_view_permissions?,        :may_administrate?
		alias_method :may_create_user_invitations?, :may_administrate?
		alias_method :may_view_users?,              :may_administrate?
		alias_method :may_assign_roles?,            :may_administrate?
		alias_method :administrator?,               :may_administrate?
		alias_method :is_administrator?,            :may_administrate?
		alias_method :may_edit_subjects?,           :may_administrate?

		def may_moderate?
			(self.role_names & ['administrator','moderator']).length > 0
		end
		alias_method :moderator?, :may_moderate?

		def editor?
			(self.role_names & ['administrator','editor']).length > 0
		end
		alias_method :is_editor?,               :editor?
		alias_method :may_maintain_pages?,      :editor?
		alias_method :may_view_home_page_pics?, :editor?

		def may_view_calendar?(*args)
			(self.role_names & ['administrator','editor','employee']).length > 0
		end
		alias_method :may_view_packages?,       :may_view_calendar?
		alias_method :may_view_subjects?,       :may_view_calendar?
		alias_method :may_view_dust_kits?,      :may_view_calendar?
		alias_method :may_view_home_exposures?, :may_view_calendar?
		alias_method :may_edit_addresses?,      :may_view_calendar?
		alias_method :may_edit_enrollments?,    :may_view_calendar?

		def employee?
			(self.role_names & ['administrator','employee']).length > 0
		end
		alias_method :may_view_responses?,            :employee?
		alias_method :may_take_surveys?,              :employee?
		alias_method :may_view_study_events?,         :employee?
		alias_method :may_create_survey_invitations?, :employee?

		def may_view_user?(user=nil)
			self.is_user?(user) || self.is_administrator?
		end

		def is_user?(user=nil)
			!user.nil? && self == user
		end
		alias_method :may_be_user?, :is_user?

		def may_share_document?(document=nil)
			document && ( 
				self.is_administrator? ||
				( document.owner && self == document.owner ) 
			)
		end

		def may_view_document?(document=nil)
			document





		end

	protected

	end

end
end
ActiveRecord::Base.send( :include, Ccls::UcbCclsEngine )
