module AccessWithHttps

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def awihttps_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_access_with_https(*actions)
			user_options = actions.extract_options!

			options = {
				:login => :admin
			}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "AWiHTTPS should get new #{awihttps_title(options)}" do
				login_as send(options[:login])
				args = options[:new] || {}
				turn_https_on
				send(:get,:new,args)
				assert_response :success
				assert_template 'new'
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:new) || options.keys.include?(:new)

			test "AWiHTTPS should post create #{awihttps_title(options)}" do
				login_as send(options[:login])
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
					{}
				end
				turn_https_on
				assert_difference("#{options[:model]}.count",1) do
					send(:post,:create,args)
				end
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:create) || options.keys.include?(:create)

			test "AWiHTTPS should get edit #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				turn_https_on
				send(:get,:edit, args)
				assert_response :success
				assert_template 'edit'
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "AWiHTTPS should put update #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				sleep 1 if obj  # if updated too quickly, updated_at won't change
				turn_https_on
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_not_equal before.to_i,after.to_i if obj
				assert_response :redirect
				assert_nil flash[:error]
			end if actions.include?(:update) || options.keys.include?(:update)

			test "AWiHTTPS should get show #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				turn_https_on
				send(:get,:show, args)
				assert_response :success
				assert_template 'show'
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:show) || options.keys.include?(:show)

			test "AWiHTTPS should delete destroy #{awihttps_title(options)}" do
				login_as send(options[:login])
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				turn_https_on
				assert_difference("#{options[:model]}.count",-1) do
					send(:delete,:destroy,args)
				end
				assert_response :redirect
				assert assigns(m_key)
				assert_nil flash[:error]
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "AWiHTTPS should get index #{awihttps_title(options)}" do
				login_as send(options[:login])
				turn_https_on
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym))
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

			test "AWiHTTPS should get index #{awihttps_title(options)} and items" do
				send(options[:before]) if !options[:before].blank?
				login_as send(options[:login])
				3.times{ send(options[:method_for_create]) } if !options[:method_for_create].blank?
				turn_https_on
				get :index
				assert_response :success
				assert_template 'index'
				assert assigns(m_key.try(:to_s).try(:pluralize).try(:to_sym))
				assert_nil flash[:error]
			end if actions.include?(:index) || options.keys.include?(:index)

		end

	end

end
require 'action_controller'
require 'action_controller/test_case'
ActionController::TestCase.send(:include, AccessWithHttps)
