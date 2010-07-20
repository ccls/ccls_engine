module RequiresValidAssociations

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_requires_valid_associations(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')

			associations.each do |assoc|
				as = assoc = assoc.to_s
				as = user_options[:as] if !user_options[:as].blank?

				test "RVA should require #{as}_id" do
					assert_difference("#{model}.count",0) do
						object = create_object("#{as}_id".to_sym => nil)
						assert object.errors.on(as.to_sym)
					end
				end

				test "RVA should require valid #{as}_id" do
					assert_difference("#{model}.count",0) do
						object = create_object("#{as}_id".to_sym => 0)
						assert object.errors.on(as.to_sym)
					end
				end

			  title = "RVA should require valid #{assoc}"
				title << " as #{user_options[:as]}" if !user_options[:as].blank?
			  test title do
			    assert_difference("#{model}.count",0) { 
			      object = create_object(
							as.to_sym => Factory.build(assoc.to_sym))
			      assert object.errors.on("#{as}_id".to_sym)
			    }    
			  end 

			end

		end
		alias_method :assert_requires_valid_association,
			:assert_requires_valid_associations
		alias_method :assert_requires_valid,
			:assert_requires_valid_associations

	end

end
ActiveSupport::TestCase.send(:include,RequiresValidAssociations)
