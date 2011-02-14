module Ccls::Assertions

	def self.included(base)
		base.extend(ClassMethods)
	end

	def assert_subject_is_eligible(subject)
		assert_nil   subject.hx_enrollment.ineligible_reason_id
		assert_equal subject.hx_enrollment.is_eligible, YNDK[:yes]
	end

	def assert_subject_is_not_eligible(subject)
		assert_not_nil subject.hx_enrollment.ineligible_reason_id
		assert_equal   subject.hx_enrollment.is_eligible, YNDK[:no]
	end

	module ClassMethods

		def assert_should_create_default_object
			#	It appears that model_name is a defined class method already in ...
			#	activesupport-####/lib/active_support/core_ext/module/model_naming.rb
			test "should create default #{model_name.sub(/Test$/,'').underscore}" do
				assert_difference( "#{model_name}.count", 1 ) do
					object = create_object
					assert !object.new_record?, 
						"#{object.errors.full_messages.to_sentence}"
				end
			end
		end

#		def assert_requires_past_date(*attr_names)
#			attr_names.each do |attr_name|
#				test "should require #{attr_name} be in the past" do
##					assert_difference( "#{model_name}.count", 1 ) do
#						object = create_object( attr_name => Chronic.parse('yesterday'))
##						assert !object.errors.on(attr_name)
#						assert_no_match(/future/, 
#							object.errors.on(attr_name).to_a.join(','))
##					end
#					assert_difference( "#{model_name}.count", 0 ) do
#						object = create_object( attr_name => Chronic.parse('tomorrow'))
#						assert object.errors.on(attr_name)
#						assert_match(/future/, 
#							object.errors.on(attr_name).to_a.join(','))
#					end
#				end
#			end
#		end
#	
#		def assert_requires_complete_date(*attr_names)
#			attr_names.each do |attr_name|
#				test "should require a complete date for #{attr_name}" do
#					assert_difference( "#{model_name}.count", 0 ) do
#						object = create_object( attr_name => "Sept 2010")
#						assert object.errors.on(attr_name)
#						#
#						#	object.errors.on CAN be an Array!
#						#
#						assert_match(/not a complete date/, 
#							object.errors.on(attr_name).to_a.join(','))
#					end
#					assert_difference( "#{model_name}.count", 0 ) do
#						object = create_object( attr_name => "9/2010")
#						assert object.errors.on(attr_name)
#						assert_match(/not a complete date/, 
#							object.errors.on(attr_name).to_a.join(','))
#					end
#				end
#			end
#		end

	end
end
ActiveSupport::TestCase.send(:include,Ccls::Assertions)
