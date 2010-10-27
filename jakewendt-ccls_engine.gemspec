# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jakewendt-ccls_engine}
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["George 'Jake' Wendt"]
  s.date = %q{2010-10-27}
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
     "app/models/user_invitation.rb",
     "app/models/user_invitation_mailer.rb",
     "app/models/user_session.rb",
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
     "generators/ccls_engine/templates/functional/javascripts_controller_test.rb",
     "generators/ccls_engine/templates/functional/roles_controller_test.rb",
     "generators/ccls_engine/templates/functional/sessions_controller_test.rb",
     "generators/ccls_engine/templates/functional/stylesheets_controller_test.rb",
     "generators/ccls_engine/templates/functional/user_invitations_controller_test.rb",
     "generators/ccls_engine/templates/functional/users_controller_test.rb",
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
     "lib/ccls_engine/core_extension.rb",
     "lib/ccls_engine/date_and_time_formats.rb",
     "lib/ccls_engine/factories.rb",
     "lib/ccls_engine/file_utils_extension.rb",
     "lib/ccls_engine/helper.rb",
     "lib/ccls_engine/pending.rb",
     "lib/ccls_engine/redcloth/formatters/html.rb",
     "lib/ccls_engine/tasks.rb",
     "lib/ccls_engine/user_model.rb",
     "lib/tasks/application.rake",
     "lib/tasks/documentation.rake",
     "lib/tasks/ucb_ccls_engine_tasks.rake"
  ]
  s.homepage = %q{http://github.com/jakewendt/ucb_ccls_engine}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{one-line summary of your gem}

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
      s.add_runtime_dependency(%q<thoughtbot-factory_girl>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-assert_this_and_that>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-calnet_authenticated>, [">= 0"])
      s.add_runtime_dependency(%q<jakewendt-simply_pages>, [">= 0"])
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
      s.add_dependency(%q<thoughtbot-factory_girl>, [">= 0"])
      s.add_dependency(%q<jakewendt-assert_this_and_that>, [">= 0"])
      s.add_dependency(%q<jakewendt-calnet_authenticated>, [">= 0"])
      s.add_dependency(%q<jakewendt-simply_pages>, [">= 0"])
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
    s.add_dependency(%q<thoughtbot-factory_girl>, [">= 0"])
    s.add_dependency(%q<jakewendt-assert_this_and_that>, [">= 0"])
    s.add_dependency(%q<jakewendt-calnet_authenticated>, [">= 0"])
    s.add_dependency(%q<jakewendt-simply_pages>, [">= 0"])
  end
end

