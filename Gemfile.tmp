# A sample Gemfile
source "http://rubygems.org"
source "http://gems.rubyforge.org"
source "http://gemcutter.org"
source "http://gems.github.com"


#	rubygems > 1.6.2 is EVIL!  If you update, you deal with it.
#		generates all kinds of new errors and deprecation warnings
#		somehow loads older versions of gems, then bitches when you try to load the newest.
#		(may be fixable with "gem pristine --all --no-extensions", but haven't tried)
#	rake 0.9.0 caused some errors.  can't remember
#	arel > 2.0.2 caused some errors.
#	some gem versions require rails 3, so have to use older versions
#		authlogic, will_paginate


#
#	NO SPACES BETWEEN OPERATOR AND VERSION NUMBER!
#
gem "rake", '=0.8.7'
gem "rails", "~>2"
#gem "test-unit"
gem "mongrel"
gem "active_shipping"
gem "RedCloth", '<4.2.8'
gem "arel", "=2.0.2"
gem "authlogic", "~>2"
gem "autotest-rails"
gem "aws-s3"
gem "aws-sdb"
gem "chronic",	'>=0.6.2'
gem "gravatar"
gem "haml"
gem "hpricot"
gem "i18n"
gem "jeweler"
gem "jrails"
gem "paperclip"

#	causes rails 2.3.2 and associated to be installed???
#gem "rack"	
# (1.3.0, 1.2.2, 1.1.2, 1.1.0, 1.0.1)

gem "rcov"
gem "rdoc"
gem "ryanb-acts-as-list"
gem "ssl_requirement"
gem "thoughtbot-factory_girl"
gem "will_paginate", "~>2"

gem "ccls-calnet_authenticated"
gem "ccls-ccls_engine"
gem "ccls-surveyor"
gem "jakewendt-html_test"
gem "jakewendt-rails_extension"
gem "jakewendt-rdoc_rails"
gem "jakewendt-ruby_extension"
gem "jakewendt-simply_authorized"
gem "jakewendt-simply_documents"
gem "jakewendt-simply_helpful"
gem "jakewendt-simply_pages"
gem "jakewendt-simply_photos"
gem "jakewendt-simply_sessions"
gem "jakewendt-simply_trackable"
gem "jakewendt-use_db"

gem 'ZenTest', '~>4.5.0'
#Fetching: ZenTest-4.6.2.gem (100%)
#ERROR:  Error installing ZenTest:
#	ZenTest requires RubyGems version ~> 1.8. (which is evil I tell you)


if RUBY_PLATFORM =~ /java/
	gem "warbler"
	gem "jruby-jars"
	gem "jruby-openssl"
	gem "jruby-rack"
	gem "jdbc-mysql"
	gem "jdbc-sqlite3"
	gem "activerecord-jdbcsqlite3-adapter"
	gem "activerecord-jdbcmysql-adapter"
else
	#	problems in jruby
	gem "mysql"
	gem "rmagick"
	gem "sqlite3", '!=1.3.4'
end

gem "fastercsv"
gem "sunspot_rails"
gem "sunspot"
gem "packet"	#	don't remember why (think from backgroundrb)

