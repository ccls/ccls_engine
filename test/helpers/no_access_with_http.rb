module NoAccessWithHttp

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def nawihttp_title(options={})
			"with #{options[:login]} login#{options[:suffix]}"
		end

		def assert_no_access_with_http(*actions)
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

			test "NAWiHTTP should NOT get new #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args = options[:new]||{}
				send(:get,:new,args)
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'new', :protocol => "https://")
			end if actions.include?(:new) || options.keys.include?(:new)

			test "NAWiHTTP should NOT post create #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args = if options[:create]
					options[:create]
				elsif options[:attributes_for_create]
					{m_key => send(options[:attributes_for_create])}
				else
					{}
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:post,:create,args)
				end
				assert_match @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'create', :protocol => "https://"),@response.redirected_to
			end if actions.include?(:create) || options.keys.include?(:create)

			test "NAWiHTTP should NOT get edit #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args=options[:edit]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'edit', :id => args[:id], :protocol => "https://")
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "NAWiHTTP should NOT put update #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args={}
				if options[:method_for_create] && options[:attributes_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
					args[m_key] = send(options[:attributes_for_create])
				end
				before = obj.updated_at if obj
				send(:put,:update, args)
				after = obj.reload.updated_at if obj
				assert_equal before.to_s(:db), after.to_s(:db) if obj
				assert_match @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'update', :id => args[:id], :protocol => "https://"), @response.redirected_to
			end if actions.include?(:update) || options.keys.include?(:update)

			test "NAWiHTTP should NOT get show #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args=options[:show]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'show', :id => args[:id], :protocol => "https://")
			end if actions.include?(:show) || options.keys.include?(:show)

			test "NAWiHTTP should NOT delete destroy #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				args=options[:destroy]||{}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:delete,:destroy,args)
				end
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'destroy', :id => args[:id], :protocol => "https://")
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "NAWiHTTP should NOT get index #{nawihttp_title(options)}" do
				turn_https_off
				login_as send(options[:login])
				get :index
				assert_redirected_to @controller.url_for(
					:controller => @controller.controller_name,
					:action => 'index', :protocol => "https://")
			end if actions.include?(:index) || options.keys.include?(:index)

		end

	end

end
ActionController::TestCase.send(:include, NoAccessWithHttp)
