module AccessWithoutLogin

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods

#	I can't imagine a whole lot of use for this one.

		def assert_access_without_login(*actions)
			user_options = actions.extract_options!

			options = {}
			if ( self.constants.include?('ASSERT_ACCESS_OPTIONS') )
				options.merge!(self::ASSERT_ACCESS_OPTIONS)
			end
			options.merge!(user_options)
			actions += options[:actions]||[]

			m_key = options[:model].try(:underscore).try(:to_sym)

#			test "should NOT get new without login" do
#				get :new
#				assert_redirected_to_login
#			end if actions.include?(:new) || options.keys.include?(:new)
#
#			test "should NOT post create without login" do
#				args = {}
#				args = if options[:create]
#					options[:create]
#				else
#					{options[:factory] => Factory.attributes_for(options[:factory])}
#				end
#				assert_no_difference("#{options[:model]}.count") do
#					send(:post,:create,args)
#				end
#				assert_redirected_to_login
#			end if actions.include?(:create) || options.keys.include?(:create)
#
#			test "should NOT get edit without login" do
#				args=[]
#				if options[:factory]
#					obj = Factory(options[:factory])
#					args.push(:id => obj.id)
#				end
#				send(:get,:edit, *args)
#				assert_redirected_to_login
#			end if actions.include?(:edit) || options.keys.include?(:edit)
#
#			test "should NOT put update without login" do
#				args={}
#				if options[:factory]
#					obj = Factory(options[:factory])
#					args[:id] = obj.id
#					args[options[:factory]] = Factory.attributes_for(options[:factory])
#				end
#				send(:put,:update, args)
#				assert_redirected_to_login
#			end if actions.include?(:update) || options.keys.include?(:update)

			test "AWoL should get show without login" do
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

#			test "should NOT delete destroy without login" do
#				args=[]
#				if options[:factory]
#					obj = Factory(options[:factory])
#					args.push(:id => obj.id)
#				end
#				assert_no_difference("#{options[:model]}.count") do
#					send(:delete,:destroy,*args)
#				end
#				assert_redirected_to_login
#			end if actions.include?(:destroy) || options.keys.include?(:destroy)
#
#			test "should NOT get index without login" do
#				get :index
#				assert_redirected_to_login
#			end if actions.include?(:index) || options.keys.include?(:index)

		end
	end
end
ActionController::TestCase.send(:include, AccessWithoutLogin)
