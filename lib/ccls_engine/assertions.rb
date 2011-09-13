module Ccls::Assertions

	def self.included(base)
		base.extend(ClassMethods)
	end

	def assert_subject_is_eligible(study_subject)
		assert_nil   study_subject.hx_enrollment.ineligible_reason_id
		assert_equal study_subject.hx_enrollment.is_eligible, YNDK[:yes]
	end
	alias_method :assert_study_subject_is_eligible, :assert_subject_is_eligible

	def assert_subject_is_not_eligible(study_subject)
		assert_not_nil study_subject.hx_enrollment.ineligible_reason_id
		assert_equal   study_subject.hx_enrollment.is_eligible, YNDK[:no]
	end
	alias_method :assert_study_subject_is_not_eligible, :assert_subject_is_not_eligible

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

	end
end
ActiveSupport::TestCase.send(:include,Ccls::Assertions)
