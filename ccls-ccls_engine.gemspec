# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ccls-ccls_engine}
  s.version = "3.7.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["George 'Jake' Wendt"]
  s.date = %q{2011-05-25}
  s.description = %q{longer description of your gem}
  s.email = %q{github@jakewendt.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "app/controllers/calendars_controller.rb",
    "app/controllers/ineligible_reasons_controller.rb",
    "app/controllers/javascripts_controller.rb",
    "app/controllers/languages_controller.rb",
    "app/controllers/people_controller.rb",
    "app/controllers/races_controller.rb",
    "app/controllers/refusal_reasons_controller.rb",
    "app/controllers/sessions_controller.rb",
    "app/controllers/stylesheets_controller.rb",
    "app/controllers/users_controller.rb",
    "app/models/address.rb",
    "app/models/address_type.rb",
    "app/models/addressing.rb",
    "app/models/aliquot.rb",
    "app/models/aliquot_sample_format.rb",
    "app/models/analysis.rb",
    "app/models/context.rb",
    "app/models/county.rb",
    "app/models/data_source.rb",
    "app/models/diagnosis.rb",
    "app/models/document_type.rb",
    "app/models/document_version.rb",
    "app/models/enrollment.rb",
    "app/models/gift_card.rb",
    "app/models/gift_card_search.rb",
    "app/models/home_exposure_response.rb",
    "app/models/homex_outcome.rb",
    "app/models/hospital.rb",
    "app/models/identifier.rb",
    "app/models/ineligible_reason.rb",
    "app/models/instrument.rb",
    "app/models/instrument_type.rb",
    "app/models/instrument_version.rb",
    "app/models/interview.rb",
    "app/models/interview_method.rb",
    "app/models/interview_outcome.rb",
    "app/models/language.rb",
    "app/models/operational_event.rb",
    "app/models/operational_event_type.rb",
    "app/models/organization.rb",
    "app/models/package.rb",
    "app/models/patient.rb",
    "app/models/person.rb",
    "app/models/phone_number.rb",
    "app/models/phone_type.rb",
    "app/models/pii.rb",
    "app/models/project.rb",
    "app/models/project_outcome.rb",
    "app/models/race.rb",
    "app/models/refusal_reason.rb",
    "app/models/sample.rb",
    "app/models/sample_kit.rb",
    "app/models/sample_outcome.rb",
    "app/models/sample_type.rb",
    "app/models/search.rb",
    "app/models/state.rb",
    "app/models/states.rb",
    "app/models/subject.rb",
    "app/models/subject_language.rb",
    "app/models/subject_race.rb",
    "app/models/subject_relationship.rb",
    "app/models/subject_search.rb",
    "app/models/subject_type.rb",
    "app/models/transfer.rb",
    "app/models/unit.rb",
    "app/models/user.rb",
    "app/models/user_session.rb",
    "app/models/vital_status.rb",
    "app/models/zip_code.rb",
    "app/views/calendars/show.html.erb",
    "app/views/ineligible_reasons/_form.html.erb",
    "app/views/ineligible_reasons/_ineligible_reason.html.erb",
    "app/views/ineligible_reasons/edit.html.erb",
    "app/views/ineligible_reasons/index.html.erb",
    "app/views/ineligible_reasons/new.html.erb",
    "app/views/ineligible_reasons/show.html.erb",
    "app/views/javascripts/cache_helper.js.erb",
    "app/views/languages/_form.html.erb",
    "app/views/languages/_language.html.erb",
    "app/views/languages/edit.html.erb",
    "app/views/languages/index.html.erb",
    "app/views/languages/new.html.erb",
    "app/views/languages/show.html.erb",
    "app/views/pages/_form.html.erb",
    "app/views/pages/show.html.erb",
    "app/views/people/_form.html.erb",
    "app/views/people/_person.html.erb",
    "app/views/people/edit.html.erb",
    "app/views/people/index.html.erb",
    "app/views/people/new.html.erb",
    "app/views/people/show.html.erb",
    "app/views/races/_form.html.erb",
    "app/views/races/_race.html.erb",
    "app/views/races/edit.html.erb",
    "app/views/races/index.html.erb",
    "app/views/races/new.html.erb",
    "app/views/races/show.html.erb",
    "app/views/refusal_reasons/_form.html.erb",
    "app/views/refusal_reasons/_refusal_reason.html.erb",
    "app/views/refusal_reasons/edit.html.erb",
    "app/views/refusal_reasons/index.html.erb",
    "app/views/refusal_reasons/new.html.erb",
    "app/views/refusal_reasons/show.html.erb",
    "app/views/stylesheets/dynamic.css.erb",
    "app/views/user_sessions/new.html.erb",
    "app/views/users/_form.html.erb",
    "app/views/users/edit.html.erb",
    "app/views/users/index.html.erb",
    "app/views/users/menu.js.erb",
    "app/views/users/new.html.erb",
    "app/views/users/show.html.erb",
    "config/home_exposure_response_fields.yml",
    "config/routes.rb",
    "config/shared_use_db.yml",
    "generators/ccls_engine/USAGE",
    "generators/ccls_engine/ccls_engine_generator.rb",
    "generators/ccls_engine/templates/autotest_ccls_engine.rb",
    "generators/ccls_engine/templates/ccls_engine.rake",
    "generators/ccls_engine/templates/functional/javascripts_controller_test.rb",
    "generators/ccls_engine/templates/functional/roles_controller_test.rb",
    "generators/ccls_engine/templates/functional/sessions_controller_test.rb",
    "generators/ccls_engine/templates/functional/stylesheets_controller_test.rb",
    "generators/ccls_engine/templates/functional/user_invitations_controller_test.rb",
    "generators/ccls_engine/templates/functional/users_controller_test.rb",
    "generators/ccls_engine/templates/initializer.rb",
    "generators/ccls_engine/templates/javascripts/jquery-ui.js",
    "generators/ccls_engine/templates/javascripts/jquery.js",
    "generators/ccls_engine/templates/javascripts/jrails.js",
    "generators/ccls_engine/templates/javascripts/ucb_ccls_engine.js",
    "generators/ccls_engine/templates/migrations/create_user_invitations.rb",
    "generators/ccls_engine/templates/migrations/create_users.rb",
    "generators/ccls_engine/templates/stylesheets/shared.css",
    "generators/ccls_engine/templates/stylesheets/user.css",
    "generators/ccls_engine/templates/stylesheets/users.css",
    "generators/ccls_engine/templates/unit/core_extension_test.rb",
    "generators/ccls_engine/templates/unit/role_test.rb",
    "generators/ccls_engine/templates/unit/user_invitation_mailer_test.rb",
    "generators/ccls_engine/templates/unit/user_invitation_test.rb",
    "generators/ccls_engine/templates/unit/user_test.rb",
    "lib/ccls-ccls_engine.rb",
    "lib/ccls_engine.rb",
    "lib/ccls_engine/assertions.rb",
    "lib/ccls_engine/autotest.rb",
    "lib/ccls_engine/ccls_subject.rb",
    "lib/ccls_engine/ccls_user.rb",
    "lib/ccls_engine/controller.rb",
    "lib/ccls_engine/core_extension.rb",
    "lib/ccls_engine/date_and_time_formats.rb",
    "lib/ccls_engine/factories.rb",
    "lib/ccls_engine/factory_test_helper.rb",
    "lib/ccls_engine/file_utils_extension.rb",
    "lib/ccls_engine/helper.rb",
    "lib/ccls_engine/package_test_helper.rb",
    "lib/ccls_engine/redcloth/formatters/html.rb",
    "lib/ccls_engine/shared.rb",
    "lib/ccls_engine/shared_database.rb",
    "lib/ccls_engine/tasks.rb",
    "lib/ccls_engine/test_helper.rb",
    "lib/ccls_engine/test_tasks.rb",
    "lib/ccls_engine/warble.rb",
    "lib/shared_migration.rb",
    "lib/surveyor/survey_extensions.rb",
    "lib/tasks/application.rake",
    "lib/tasks/database.rake",
    "lib/tasks/documentation.rake",
    "lib/tasks/import.rake",
    "lib/tasks/simply_authorized.rake",
    "lib/tasks/simply_helpful.rake",
    "lib/tasks/simply_pages.rake",
    "lib/tasks/simply_trackable.rake",
    "lib/tasks/ucb_ccls_engine_tasks.rake",
    "lib/tasks/use_db.rake"
  ]
  s.homepage = %q{http://github.com/ccls/ucb_ccls_engine}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{one-line summary of your gem}
  s.test_files = ["test/app/models/home_page_pic.rb", "test/config/routes.rb", "test/factories.rb", "test/functional/ccls/calendars_controller_test.rb", "test/functional/ccls/ineligible_reasons_controller_test.rb", "test/functional/ccls/javascripts_controller_test.rb", "test/functional/ccls/languages_controller_test.rb", "test/functional/ccls/people_controller_test.rb", "test/functional/ccls/races_controller_test.rb", "test/functional/ccls/refusal_reasons_controller_test.rb", "test/functional/ccls/roles_controller_test.rb", "test/functional/ccls/sessions_controller_test.rb", "test/functional/ccls/stylesheets_controller_test.rb", "test/functional/ccls/users_controller_test.rb", "test/helpers/authlogic_test_helper.rb", "test/unit/ccls/address_test.rb", "test/unit/ccls/address_type_test.rb", "test/unit/ccls/addressing_test.rb", "test/unit/ccls/aliquot_sample_format_test.rb", "test/unit/ccls/aliquot_test.rb", "test/unit/ccls/analysis_test.rb", "test/unit/ccls/context_test.rb", "test/unit/ccls/core_extension_test.rb", "test/unit/ccls/county_test.rb", "test/unit/ccls/data_source_test.rb", "test/unit/ccls/diagnosis_test.rb", "test/unit/ccls/document_type_test.rb", "test/unit/ccls/document_version_test.rb", "test/unit/ccls/enrollment_test.rb", "test/unit/ccls/gift_card_search_test.rb", "test/unit/ccls/gift_card_test.rb", "test/unit/ccls/helpers/ccls_engine_helper_test.rb", "test/unit/ccls/home_exposure_response_test.rb", "test/unit/ccls/homex_outcome_test.rb", "test/unit/ccls/hospital_test.rb", "test/unit/ccls/identifier_test.rb", "test/unit/ccls/ineligible_reason_test.rb", "test/unit/ccls/instrument_test.rb", "test/unit/ccls/instrument_type_test.rb", "test/unit/ccls/instrument_version_test.rb", "test/unit/ccls/interview_method_test.rb", "test/unit/ccls/interview_outcome_test.rb", "test/unit/ccls/interview_test.rb", "test/unit/ccls/language_test.rb", "test/unit/ccls/operational_event_test.rb", "test/unit/ccls/operational_event_type_test.rb", "test/unit/ccls/organization_test.rb", "test/unit/ccls/package_test.rb", "test/unit/ccls/patient_test.rb", "test/unit/ccls/person_test.rb", "test/unit/ccls/phone_number_test.rb", "test/unit/ccls/phone_type_test.rb", "test/unit/ccls/pii_test.rb", "test/unit/ccls/project_outcome_test.rb", "test/unit/ccls/project_test.rb", "test/unit/ccls/race_test.rb", "test/unit/ccls/refusal_reason_test.rb", "test/unit/ccls/role_test.rb", "test/unit/ccls/sample_kit_test.rb", "test/unit/ccls/sample_outcome_test.rb", "test/unit/ccls/sample_test.rb", "test/unit/ccls/sample_type_test.rb", "test/unit/ccls/state_test.rb", "test/unit/ccls/subject_language_test.rb", "test/unit/ccls/subject_race_test.rb", "test/unit/ccls/subject_relationship_test.rb", "test/unit/ccls/subject_search_test.rb", "test/unit/ccls/subject_test.rb", "test/unit/ccls/subject_type_test.rb", "test/unit/ccls/transfer_test.rb", "test/unit/ccls/unit_test.rb", "test/unit/ccls/user_test.rb", "test/unit/ccls/vital_status_test.rb", "test/unit/ccls/zip_code_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 2"])
      s.add_runtime_dependency(%q<activerecord>, ["~> 2"])
      s.add_runtime_dependency(%q<activeresource>, ["~> 2"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 2"])
      s.add_runtime_dependency(%q<actionpack>, ["~> 2"])
      s.add_runtime_dependency(%q<jrails>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_helpful>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-ruby_extension>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_authorized>, [">= 0"])
      s.add_runtime_dependency(%q<chronic>, [">= 0"])
      s.add_runtime_dependency(%q<ssl_requirement>, [">= 0"])
      s.add_runtime_dependency(%q<ryanb-acts-as-list>, [">= 0"])
      s.add_runtime_dependency(%q<gravatar>, [">= 0"])
      s.add_runtime_dependency(%q<paperclip>, [">= 0"])
      s.add_runtime_dependency(%q<thoughtbot-factory_girl>, [">= 0"])
      s.add_runtime_dependency(%q<ucb_ldap>, [">= 1.4.2"])
      s.add_runtime_dependency(%q<rubycas-client>, [">= 2.2.1"])
      s.add_runtime_dependency(%q<jakewendt-simply_pages>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-use_db>, [">= 0"])
      s.add_runtime_dependency(%q<ccls-surveyor>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_trackable>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-rails_extension>, [">= 0"])
      s.add_runtime_dependency(%q<RedCloth>, ["!= 4.2.6"])
    else
      s.add_dependency(%q<rails>, ["~> 2"])
      s.add_dependency(%q<activerecord>, ["~> 2"])
      s.add_dependency(%q<activeresource>, ["~> 2"])
      s.add_dependency(%q<activesupport>, ["~> 2"])
      s.add_dependency(%q<actionpack>, ["~> 2"])
      s.add_dependency(%q<jrails>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_helpful>, [">= 0"])
      s.add_dependency(%q<jakewendt-ruby_extension>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_authorized>, [">= 0"])
      s.add_dependency(%q<chronic>, [">= 0"])
      s.add_dependency(%q<ssl_requirement>, [">= 0"])
      s.add_dependency(%q<ryanb-acts-as-list>, [">= 0"])
      s.add_dependency(%q<gravatar>, [">= 0"])
      s.add_dependency(%q<paperclip>, [">= 0"])
      s.add_dependency(%q<thoughtbot-factory_girl>, [">= 0"])
      s.add_dependency(%q<ucb_ldap>, [">= 1.4.2"])
      s.add_dependency(%q<rubycas-client>, [">= 2.2.1"])
      s.add_dependency(%q<jakewendt-simply_pages>, [">= 0"])
      s.add_dependency(%q<jakewendt-use_db>, [">= 0"])
      s.add_dependency(%q<ccls-surveyor>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_trackable>, [">= 0"])
      s.add_dependency(%q<jakewendt-rails_extension>, [">= 0"])
      s.add_dependency(%q<RedCloth>, ["!= 4.2.6"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 2"])
    s.add_dependency(%q<activerecord>, ["~> 2"])
    s.add_dependency(%q<activeresource>, ["~> 2"])
    s.add_dependency(%q<activesupport>, ["~> 2"])
    s.add_dependency(%q<actionpack>, ["~> 2"])
    s.add_dependency(%q<jrails>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_helpful>, [">= 0"])
    s.add_dependency(%q<jakewendt-ruby_extension>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_authorized>, [">= 0"])
    s.add_dependency(%q<chronic>, [">= 0"])
    s.add_dependency(%q<ssl_requirement>, [">= 0"])
    s.add_dependency(%q<ryanb-acts-as-list>, [">= 0"])
    s.add_dependency(%q<gravatar>, [">= 0"])
    s.add_dependency(%q<paperclip>, [">= 0"])
    s.add_dependency(%q<thoughtbot-factory_girl>, [">= 0"])
    s.add_dependency(%q<ucb_ldap>, [">= 1.4.2"])
    s.add_dependency(%q<rubycas-client>, [">= 2.2.1"])
    s.add_dependency(%q<jakewendt-simply_pages>, [">= 0"])
    s.add_dependency(%q<jakewendt-use_db>, [">= 0"])
    s.add_dependency(%q<ccls-surveyor>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_trackable>, [">= 0"])
    s.add_dependency(%q<jakewendt-rails_extension>, [">= 0"])
    s.add_dependency(%q<RedCloth>, ["!= 4.2.6"])
  end
end

