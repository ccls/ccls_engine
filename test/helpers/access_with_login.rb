module AccessWithLogin

	def self.included(base)
		base.extend ClassMethods
		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def awil_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_access_with_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

#			o = {
#				:actions => {
#					:new => {
#						:request => [ :get, :new ]
#					}
#				}
#			}

			logins = Array(options[:logins]||options[:login])
			logins.each do |login|
				#	options[:login] is set for the title,
				#	but "login_as send(login)" as options[:login]
				#	will be the last in the array at runtime.
				options[:login] = login

			test "AWiL should get new #{awil_title(options)}" do
				login_as send(login)
				args = options[:new] || {}
				send(:get,:new,args)
				assert_response :success
				assert_template 'new'
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:new) || options.keys.include?(:new)

			test "AWiL should post create #{awil_title(options)}" do
				login_as send(login)
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
					{}
				end
				assert_difference("#{options[:model]}.count",1) do
					send(:post,:create,args)
				end
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:create) || options.keys.include?(:create)

			test "AWiL should get edit #{awil_title(options)}" do
				login_as send(login)
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_response :success
				assert_template 'edit'
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "AWiL should put update #{awil_title(options)}" do
				login_as send(login)
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				sleep 1 if obj	#	if updated too quickly, updated_at won't change
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_not_equal before.to_i,after.to_i if obj
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:update) || options.keys.include?(:update)

			test "AWiL should get show #{awil_title(options)}" do
				login_as send(login)
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_response :success
				assert_template 'show'
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:show) || options.keys.include?(:show)

			test "AWiL should delete destroy #{awil_title(options)}" do
				login_as send(login)
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				assert_difference("#{options[:model]}.count",-1) do
					send(:delete,:destroy,args)
				end
				assert_response :redirect
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "AWiL should get index #{awil_title(options)}" do
				login_as send(login)
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym))
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

			test "AWiL should get index #{awil_title(options)} and items" do
				send(options[:before]) if !options[:before].blank?
				login_as send(login)
				3.times{ send(options[:method_for_create]) } if !options[:method_for_create].blank?
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym))
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

			end	#	logins.each
		end

	end

	module InstanceMethods

	end
end
ActionController::TestCase.send(:include, AccessWithLogin)
