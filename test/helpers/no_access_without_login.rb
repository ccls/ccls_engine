module NoAccessWithoutLogin

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

		def assert_no_access_without_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

			test "NAWoL should NOT get new without login" do
				get :new
				assert_redirected_to_login
			end if actions.include?(:new) || options.keys.include?(:new)

			test "NAWoL should NOT post create without login" do
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
				assert_redirected_to_login
			end if actions.include?(:create) || options.keys.include?(:create)

			test "NAWoL should NOT get edit without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:edit, args)
				assert_redirected_to_login
			end if actions.include?(:edit) || options.keys.include?(:edit)

			test "NAWoL should NOT put update without login" do
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
				assert_redirected_to_login
			end if actions.include?(:update) || options.keys.include?(:update)

			test "NAWoL should NOT get show without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				send(:get,:show, args)
				assert_redirected_to_login
			end if actions.include?(:show) || options.keys.include?(:show)

			test "NAWoL should NOT delete destroy without login" do
				args={}
				if options[:method_for_create]
					obj = send(options[:method_for_create])
					args[:id] = obj.id
				end
				assert_no_difference("#{options[:model]}.count") do
					send(:delete,:destroy,args)
				end
				assert_redirected_to_login
			end if actions.include?(:destroy) || options.keys.include?(:destroy)

			test "NAWoL should NOT get index without login" do
				get :index
				assert_redirected_to_login
			end if actions.include?(:index) || options.keys.include?(:index)

		end
	end
end
require 'action_controller'
require 'action_controller/test_case'
ActionController::TestCase.send(:include, NoAccessWithoutLogin)
