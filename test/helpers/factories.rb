Factory.define :document do |f|
end

Factory.define :image do |f|
end

Factory.define :page do |f|
	f.sequence(:path) { |n| "/path#{n}" }
	f.sequence(:menu_en) { |n| "Menu #{n}" }
	f.sequence(:title_en){ |n| "Title #{n}" }
	f.body_en  "Page Body"
end

Factory.define :role do |f|
	f.sequence(:name) { |n| "name#{n}" }
end

Factory.define :user do |f|
	f.sequence(:uid) { |n| "UID#{n}" }
#	f.sequence(:username) { |n| "username#{n}" }
#	f.sequence(:email) { |n| "username#{n}@example.com" }
#	f.password 'V@1!dP@55w0rd'
#	f.password_confirmation 'V@1!dP@55w0rd'
#	f.role_name 'user'
end
Factory.define :admin_user, :parent => :user do |f|
	f.administrator true
end	#	parent must be defined first
Factory.define :sender, :parent => :user do |f|
#	This is really just an alias of convenience for UserInvitation
end	#	parent must be defined first

Factory.define :user_invitation do |f|
	f.association :sender, :factory => :user
	f.sequence(:email){|n| "invitation#{n}@example.com"}
end
