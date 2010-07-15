module ShouldRequire

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_should_require_unique_attribute(*attributes)
			user_options = attributes.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			attributes.each do |attr|
				attr = attr.to_s
				test "SR should require unique #{attr}" do
					o = create_object
					assert_no_difference "#{model}.count" do
						object = create_object(attr.to_sym => o.send(attr))
						assert object.errors.on(attr.to_sym)
					end
				end
			end
		end

		def assert_should_require_attribute(*attributes)
			user_options = attributes.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			attributes.each do |attr|
				attr = attr.to_s
				test "SR should require #{attr}" do
					assert_no_difference "#{model}.count" do
						object = create_object(attr.to_sym => nil)
						assert object.errors.on(attr.to_sym)
					end
				end
			end
		end

		alias_method :assert_should_require, 
			:assert_should_require_attribute
		alias_method :assert_should_require_unique, 
			:assert_should_require_unique_attribute

	end

end
ActiveSupport::TestCase.send(:include,ShouldRequire)
