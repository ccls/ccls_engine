# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jakewendt-ccls_engine}
  s.version = "1.2.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["George 'Jake' Wendt"]
  s.date = %q{2010-12-01}
  s.description = %q{longer description of your gem}
  s.email = %q{github@jake.otherinbox.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "app/controllers/javascripts_controller.rb",
    "app/controllers/stylesheets_controller.rb",
    "app/controllers/user_invitations_controller.rb",
    "app/controllers/users_controller.rb",
    "app/models/maker.rb",
    "app/models/user_invitation.rb",
    "app/models/user_invitation_mailer.rb",
    "app/models/user_session.rb",
    "app/models/widget.rb",
    "app/views/javascripts/cache_helper.js.erb",
    "app/views/stylesheets/dynamic.css.erb",
    "app/views/user_invitation_mailer/invitation.erb",
    "app/views/user_invitations/new.html.erb",
    "app/views/user_sessions/new.html.erb",
    "app/views/users/_form.html.erb",
    "app/views/users/edit.html.erb",
    "app/views/users/index.html.erb",
    "app/views/users/menu.js.erb",
    "app/views/users/new.html.erb",
    "app/views/users/show.html.erb",
    "config/routes.rb",
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
    "lib/ccls_engine.rb",
    "lib/ccls_engine/autotest.rb",
    "lib/ccls_engine/core_extension.rb",
    "lib/ccls_engine/date_and_time_formats.rb",
    "lib/ccls_engine/factories.rb",
    "lib/ccls_engine/file_utils_extension.rb",
    "lib/ccls_engine/helper.rb",
    "lib/ccls_engine/redcloth/formatters/html.rb",
    "lib/ccls_engine/shared_database.rb",
    "lib/ccls_engine/tasks.rb",
    "lib/ccls_engine/test_tasks.rb",
    "lib/ccls_engine/user_model.rb",
    "lib/ccls_engine/warble.rb",
    "lib/tasks/application.rake",
    "lib/tasks/calnet_authenticated.rake",
    "lib/tasks/documentation.rake",
    "lib/tasks/simply_authorized.rake",
    "lib/tasks/simply_helpful.rake",
    "lib/tasks/simply_pages.rake",
    "lib/tasks/ucb_ccls_engine_tasks.rake",
    "lib/tasks/use_db.rake"
  ]
  s.homepage = %q{http://github.com/jakewendt/ucb_ccls_engine}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{one-line summary of your gem}
  s.test_files = [
    "test/app/controllers/application_controller.rb",
    "test/app/models/home_page_pic.rb",
    "test/app/models/user.rb",
    "test/config/routes.rb",
    "test/db/migrate/20100129183000_create_users.rb",
    "test/db/migrate/20100216172803_create_pages.rb",
    "test/db/migrate/20100512165245_create_user_invitations.rb",
    "test/db/migrate/20100618220110_create_roles.rb",
    "test/db/migrate/20100618220452_create_roles_users.rb",
    "test/db/migrate/20100714195841_create_photos.rb",
    "test/db/migrate/20100714195926_add_attachments_image_to_photo.rb",
    "test/db/migrate/20100714200248_create_documents.rb",
    "test/db/migrate/20100714200317_add_attachments_document_to_document.rb",
    "test/db/migrate/20101029225331_add_calnet_authenticated_columns_to_users.rb",
    "test/factories.rb",
    "test/functional/ccls/javascripts_controller_test.rb",
    "test/functional/ccls/roles_controller_test.rb",
    "test/functional/ccls/sessions_controller_test.rb",
    "test/functional/ccls/stylesheets_controller_test.rb",
    "test/functional/ccls/user_invitations_controller_test.rb",
    "test/functional/ccls/users_controller_test.rb",
    "test/helpers/authlogic_test_helper.rb",
    "test/unit/ccls/core_extension_test.rb",
    "test/unit/ccls/role_test.rb",
    "test/unit/ccls/user_invitation_mailer_test.rb",
    "test/unit/ccls/user_invitation_test.rb",
    "test/unit/ccls/user_test.rb",
    "test/unit/maker_test.rb",
    "test/unit/widget_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 2"])
      s.add_runtime_dependency(%q<jrails>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_helpful>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-ruby_extension>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_authorized>, [">= 0"])
      s.add_runtime_dependency(%q<chronic>, [">= 0"])
      s.add_runtime_dependency(%q<ssl_requirement>, [">= 0"])
      s.add_runtime_dependency(%q<ryanb-acts-as-list>, [">= 0"])
      s.add_runtime_dependency(%q<gravatar>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-calnet_authenticated>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_pages>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-use_db>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 2"])
      s.add_dependency(%q<jrails>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_helpful>, [">= 0"])
      s.add_dependency(%q<jakewendt-ruby_extension>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_authorized>, [">= 0"])
      s.add_dependency(%q<chronic>, [">= 0"])
      s.add_dependency(%q<ssl_requirement>, [">= 0"])
      s.add_dependency(%q<ryanb-acts-as-list>, [">= 0"])
      s.add_dependency(%q<gravatar>, [">= 0"])
      s.add_dependency(%q<jakewendt-calnet_authenticated>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_pages>, [">= 0"])
      s.add_dependency(%q<jakewendt-use_db>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 2"])
    s.add_dependency(%q<jrails>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_helpful>, [">= 0"])
    s.add_dependency(%q<jakewendt-ruby_extension>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_authorized>, [">= 0"])
    s.add_dependency(%q<chronic>, [">= 0"])
    s.add_dependency(%q<ssl_requirement>, [">= 0"])
    s.add_dependency(%q<ryanb-acts-as-list>, [">= 0"])
    s.add_dependency(%q<gravatar>, [">= 0"])
    s.add_dependency(%q<jakewendt-calnet_authenticated>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_pages>, [">= 0"])
    s.add_dependency(%q<jakewendt-use_db>, [">= 0"])
  end
end

