module CclsEngine
module UserModel

	def self.included(base)
		base.extend(PrepMethod)
	end

	module PrepMethod
		def ucb_authenticated(options={})
			calnet_authenticated(options)
			authorized(options)

			include CclsEngine::UserModel::InstanceMethods
			extend  CclsEngine::UserModel::ClassMethods

			#	gravatar can't deal with a nil email
			gravatar :mail, :rating => 'PG'

		end
	end

	module ClassMethods

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
			self.all( 
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

	protected

	end

end	# module UserModel
end	# module CclsEngine
ActiveRecord::Base.send( :include, CclsEngine::UserModel )
