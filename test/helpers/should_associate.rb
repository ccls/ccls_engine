module ShouldAssociate

	def self.included(base)
		base.extend ClassMethods
#		base.send(:include,InstanceMethods)
	end

	module ClassMethods

		def assert_should_initially_belong_to(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize

				title = "SA should initially belong to #{assoc}"
				if !user_options[:class_name].blank?
					title << " ( #{user_options[:class_name]} )"
					class_name = user_options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_not_nil object.send(assoc)
					if object.send(assoc).respond_to?(
						"#{model.underscore.pluralize}_count")
						assert_equal 1, object.reload.send(assoc).send(
							"#{model.underscore.pluralize}_count")
					end
					if !user_options[:class_name].blank?
						assert object.send(assoc).is_a?(class_name.constantize)
					end
				end

			end

		end

		def assert_should_belong_to(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize
				title = "SA should belong to #{assoc}" 
#				if !user_options[:as].blank?
#					title << " as #{user_options[:as]}"
#					as = user_options[:as]
#				end
				if !user_options[:class_name].blank?
					title << " ( #{user_options[:class_name]} )"
					class_name = user_options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_nil object.send(assoc)
					object.send("#{assoc}=",Factory(class_name.underscore))
					assert_not_nil object.send(assoc)
					assert object.send(assoc).is_a?(class_name.constantize)
				end

			end

		end

		def assert_should_have_one(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				assoc = assoc.to_s

				test "SA should have one #{assoc}" do
					object = create_object
					assert_nil object.send(assoc)
					Factory(assoc, "#{model.underscore}_id".to_sym => object.id)
					assert_not_nil object.reload.send(assoc)
					object.send(assoc).destroy
					assert_nil object.reload.send(assoc)
				end

			end

		end

		def assert_should_have_many_(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')

			foreign_key = if !user_options[:foreign_key].blank?
				user_options[:foreign_key].to_sym
			else
				"#{model.underscore}_id".to_sym
			end

			associations.each do |assoc|
				class_name = ( assoc = assoc.to_s ).camelize

				title = "SA should have many #{assoc}"
				if !user_options[:class_name].blank?
					title << " ( #{user_options[:class_name]} )"
					class_name = user_options[:class_name].to_s
				end
				test title do
					object = create_object
					assert_equal 0, object.send(assoc).length
					Factory(class_name.singularize.underscore, 
						foreign_key => object.id)
#	doesn't work for all
#object.send(assoc) << Factory(assoc.singularize)
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					Factory(class_name.singularize.underscore, 
						foreign_key => object.id)
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end

			end

		end
		alias_method :assert_should_have_many, 
			:assert_should_have_many_
		alias_method :assert_should_have_many_associations, 
			:assert_should_have_many_

		def assert_should_habtm(*associations)
			user_options = associations.extract_options!
			model = user_options[:model] || self.name.sub(/Test$/,'')
			
			associations.each do |assoc|
				assoc = assoc.to_s

				test "SA should habtm #{assoc}" do
					object = create_object
					assert_equal 0, object.send(assoc).length
					object.send(assoc) << Factory(assoc.singularize)
					assert_equal 1, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 1, object.reload.send("#{assoc}_count")
					end
					object.send(assoc) << Factory(assoc.singularize)
					assert_equal 2, object.reload.send(assoc).length
					if object.respond_to?("#{assoc}_count")
						assert_equal 2, object.reload.send("#{assoc}_count")
					end
				end

			end

		end

	end
end
require 'active_support'
require 'active_support/test_case'
ActiveSupport::TestCase.send(:include,ShouldAssociate)
